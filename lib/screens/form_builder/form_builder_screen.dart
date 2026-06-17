import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf_kit_editor/pdf_kit_editor.dart';
import 'package:uuid/uuid.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/form_template.dart';
import '../../view_models/forms_controller.dart';
import '../../services/locator.dart';
import '../../services/pdf_service.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_primary_button.dart';

class FormBuilderScreen extends StatefulWidget {
  final FormTemplate? initialForm;
  const FormBuilderScreen({super.key, this.initialForm});

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  late PdfTemplate _template;
  late TextEditingController _nameController;
  final FormsController _formsController = locator<FormsController>();
  
  bool _isSaving = false;
  bool _isPatientPreview = false;
  
  // Mock data for live preview
  final Map<String, dynamic> _previewData = {
    'patient_name': 'John Doe',
    'patient_email': 'john.doe@example.com',
    'date': '2023-10-27',
    'notes': 'Patient has a history of skin sensitivity.',
    'agree': true,
    'signature': 'John Doe',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialForm?.name ?? "New Consent Form",
    );
    
    if (widget.initialForm?.templateJson != null) {
      try {
        final decoded = jsonDecode(widget.initialForm!.templateJson!);
        _template = PdfTemplate.fromJson(decoded);
      } catch (e) {
        _template = PdfTemplate(
          id: const Uuid().v4(),
          name: _nameController.text,
          elements: [],
        );
      }
    } else {
      _template = PdfTemplate(
        id: const Uuid().v4(),
        name: _nameController.text,
        elements: [],
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_nameController.text.isEmpty) {
      _showSnackBar("Please enter a form name", isError: true);
      return;
    }

    setState(() => _isSaving = true);
    try {
      final name = _formsController.getUniqueName(_nameController.text);
      
      final pdfBytes = await PdfService.generateFromTemplate(_template, _previewData);
      
      String filePath = '';
      if (kIsWeb) {
        filePath = "${name.replaceAll(' ', '_')}.pdf";
      } else {
        final output = await getApplicationDocumentsDirectory();
        final fileName = "${name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf";
        final file = File("${output.path}/$fileName");
        await file.writeAsBytes(pdfBytes);
        filePath = file.path;
      }
      
      final template = FormTemplate(
        id: widget.initialForm?.id ?? const Uuid().v4(),
        name: name,
        filePath: filePath,
        templateJson: jsonEncode(_template.toJson()),
        createdAt: DateTime.now(),
        isUserCreated: true,
      );

      // We need to handle the PDF file generation too if required by the existing system
      // But the requirement says "Store form configuration as structured JSON".
      
      await _formsController.saveForm(template);
      
      if (mounted) {
        _showSnackBar("Form saved successfully");
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar("Failed to save form: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? CustomColors.red : CustomColors.green,
      ),
    );
  }

  void _addElement(PdfElement element) {
    setState(() {
      _template = _template.copyWith(
        elements: [..._template.elements, element],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.softGrey,
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Left Side: Controls
          Container(
            width: 350.w,
            color: CustomColors.white,
            child: _buildControlsPanel(),
          ),
          
          // Divider
          const VerticalDivider(width: 1, color: CustomColors.border),
          
          // Right Side: Live Preview / Editor
          Expanded(
            child: _buildEditorCanvas(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: TextField(
        controller: _nameController,
        style: context.fonts.black18w600,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "Enter Form Name",
        ),
      ),
      actions: [
        _buildTogglePreviewButton(),
        SizedBox(width: 12.w),
        CustomPrimaryButton(
          label: "Save Form",
          onTap: _saveForm,
          isLoading: _isSaving,
          width: 140.w,
          height: 40.h,
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _buildTogglePreviewButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: CustomColors.softGrey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _previewToggleOption("Builder", !_isPatientPreview),
          _previewToggleOption("Patient", _isPatientPreview),
        ],
      ),
    );
  }

  Widget _previewToggleOption(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _isPatientPreview = label == "Patient"),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? CustomColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: isActive ? AppShadows.xs(context) : [],
        ),
        child: Text(
          label,
          style: isActive ? context.fonts.black12w600 : context.fonts.grey12w400,
        ),
      ),
    );
  }

  Widget _buildControlsPanel() {
    return ListView(
      padding: EdgeInsets.all(20.w),
      children: [
        Text("Form Elements", style: context.fonts.black16w600),
        SizedBox(height: 16.h),
        
        _buildElementGroup("Text Fields", [
          _elementTile(Icons.short_text, "Short Text", () {
            _addElement(const PdfElement.text(text: "New Text Field", dataKey: 'new_field'));
          }),
          _elementTile(Icons.notes, "Multiline Text", () {
             _addElement(const PdfElement.text(text: "New Notes Field", dataKey: 'new_notes'));
          }),
        ]),
        
        _buildElementGroup("Selection", [
          _elementTile(Icons.check_box, "Checkbox", () {
             // Simulating checkbox with text for now if PdfElement doesn't support it directly
             _addElement(const PdfElement.text(text: "[ ] Agree to terms", dataKey: 'agree'));
          }),
          _elementTile(Icons.radio_button_checked, "Radio Group", () {
             _addElement(const PdfElement.text(text: "( ) Option 1  ( ) Option 2"));
          }),
          _elementTile(Icons.arrow_drop_down_circle, "Dropdown", () {
             _addElement(const PdfElement.text(text: "Select Option: _________"));
          }),
        ]),
        
        _buildElementGroup("Interactive", [
          _elementTile(Icons.calendar_today, "Date Field", () {
             _addElement(const PdfElement.text(text: "Date: _________"));
          }),
          _elementTile(Icons.gesture, "Signature", () {
             _addElement(const PdfElement.text(text: "Signature: ________________", isBold: true));
          }),
          _elementTile(Icons.person_outline, "Initial Field", () {
             _addElement(const PdfElement.text(text: "Initials: ___"));
          }),
        ]),
        
        _buildElementGroup("Layout", [
          _elementTile(Icons.title, "Section Header", () {
             _addElement(const PdfElement.text(text: "NEW SECTION", isBold: true));
          }),
          _elementTile(Icons.text_fields, "Static Text", () {
             _addElement(const PdfElement.text(text: "Enter your content here..."));
          }),
          _elementTile(Icons.horizontal_rule, "Divider", () {
             _addElement(const PdfElement.divider());
          }),
        ]),
        
        SizedBox(height: 32.h),
        Text("Form Settings", style: context.fonts.black16w600),
        SizedBox(height: 16.h),
        _buildSwitchTile("Required Fields", true, (v) {}),
        _buildSwitchTile("Auto-save Draft", true, (v) {}),
      ],
    );
  }

  Widget _buildElementGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(title, style: context.fonts.grey12w600),
        ),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: children,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _elementTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 145.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.border),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: CustomColors.purple, size: 24.sp),
            SizedBox(height: 8.h),
            Text(label, style: context.fonts.black12w400, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: context.fonts.black14w400),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CustomColors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildEditorCanvas() {
    if (_isPatientPreview) {
      return Container(
        padding: EdgeInsets.all(40.w),
        child: Center(
          child: Card(
            elevation: 4,
            child: Container(
              width: 800.w,
              padding: EdgeInsets.all(40.w),
              child: PdfPreview(
                build: (format) => PdfService.generateFromTemplate(_template, _previewData),
                useActions: false,
                allowPrinting: false,
                allowSharing: false,
              ),
            ),
          ),
        ),
      );
    }

    return PdfKitEditor(
      data: _previewData,
      initialTemplate: _template,
      onSave: (template) {
        setState(() {
          _template = template;
        });
      },
      showSaveButton: false,
      showShareButton: false,
      hideDataViewer: true,
    );
  }
}
