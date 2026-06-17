import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:uuid/uuid.dart';

import '../../models/form_component.dart';
import '../../models/form_template.dart';
import '../../services/locator.dart';
import '../../services/pdf_service.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../../view_models/forms_controller.dart';

class FormBuilderScreen extends StatefulWidget {
  const FormBuilderScreen({super.key});

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  final List<FormComponent> _components = [];
  final TextEditingController _nameController = TextEditingController(
    text: "Untitled Form",
  );
  late final QuillController _quillController;
  final FormsController _formsController = locator<FormsController>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  Future<void> _onWillPop(bool didPop, bool? result) async {
    log('POP: $didPop');
    if (_quillController.document.isEmpty() && _components.isEmpty) return;
    if (didPop) {
      return;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Discard Changes?"),
        content: const Text(
          "You have unsaved changes. Are you sure you want to leave?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Discard"),
          ),
        ],
      ),
    );
    if (shouldPop ?? false) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      onPopInvokedWithResult: _onWillPop,
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _nameController,
            style: CustomFonts.black18w600,
            decoration: const InputDecoration(
              hintText: "Form Name",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
          actions: [
            _isSaving
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveForm,
                    tooltip: "Save Form",
                  ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: CustomColors.softGrey,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: QuillSimpleToolbar(
                  controller: _quillController,
                  config: const QuillSimpleToolbarConfig(
                    showSearchButton: false,
                    showLink: false,
                    showQuote: false,
                    showCodeBlock: false,
                    showIndent: false,
                    showListCheck: false,
                    showSubscript: false,
                    showSuperscript: false,
                    showUndo: true,
                    showRedo: true,
                    showDirection: false,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Row(
          children: [
            if (context.isTablet || context.isDesktop)
              _buildPalette(isVertical: true),
            Expanded(child: _buildCanvas()),
          ],
        ),
        bottomSheet: context.isMobile ? _buildPalette(isVertical: false) : null,
      ),
    );
  }

  Widget _buildPalette({required bool isVertical}) {
    final List<_PaletteItem> items = [
      _PaletteItem(
        type: FormComponentType.textField,
        icon: Icons.short_text,
        label: "Text Field",
      ),
      _PaletteItem(
        type: FormComponentType.textArea,
        icon: Icons.notes,
        label: "Text Area",
      ),
      _PaletteItem(
        type: FormComponentType.checkbox,
        icon: Icons.check_box,
        label: "Checkbox",
      ),
      _PaletteItem(
        type: FormComponentType.toggle,
        icon: Icons.toggle_on,
        label: "Switch",
      ),
      _PaletteItem(
        type: FormComponentType.dropdown,
        icon: Icons.arrow_drop_down_circle,
        label: "Dropdown",
      ),
      _PaletteItem(
        type: FormComponentType.datePicker,
        icon: Icons.calendar_today,
        label: "Date Picker",
      ),
      _PaletteItem(
        type: FormComponentType.signaturePad,
        icon: Icons.gesture,
        label: "Signature",
      ),
      _PaletteItem(
        type: FormComponentType.imagePlaceholder,
        icon: Icons.image,
        label: "Image",
      ),
      _PaletteItem(
        type: FormComponentType.divider,
        icon: Icons.horizontal_rule,
        label: "Divider",
      ),
    ];

    if (isVertical) {
      return Container(
        width: 120.w,
        color: CustomColors.softGrey,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => _buildPaletteTile(items[index]),
        ),
      );
    } else {
      return Container(
        height: 100.h,
        color: CustomColors.softGrey,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => _buildPaletteTile(items[index]),
        ),
      );
    }
  }

  Widget _buildPaletteTile(_PaletteItem item) {
    return Draggable<FormComponentType>(
      data: item.type,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(8.w),
          color: CustomColors.purple,
          child: Icon(item.icon, color: Colors.white),
        ),
      ),
      child: GestureDetector(
        onTap: () => _addComponent(item.type),
        child: Container(
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: CustomColors.purple),
              Text(
                item.label,
                style: CustomFonts.grey12w400,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCanvas() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(24.w),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            // width: 500.w,
            width: pdf.PdfPageFormat.a4.width,
            constraints: BoxConstraints(minHeight: 700.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: DragTarget<FormComponentType>(
              onAcceptWithDetails: (details) {
                _addComponent(details.data);
              },
              builder: (context, candidateData, rejectedData) {
                return Padding(
                  padding: EdgeInsets.all(40.w),
                  child: QuillEditor.basic(
                    controller: _quillController,
                    config: QuillEditorConfig(
                      // readOnly: false,
                      autoFocus: true,
                      expands: false,
                      padding: EdgeInsets.zero,
                      scrollable: false,
                      embedBuilders: [
                        FormEmbedBuilder(
                          onChanged: (comp) {
                            final index = _components.indexWhere(
                              (c) => c.id == comp.id,
                            );
                            if (index != -1) {
                              setState(() {
                                _components[index] = comp;
                              });
                            }
                          },
                          onDelete: (id) {
                            setState(() {
                              _components.removeWhere((c) => c.id == id);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _addComponent(FormComponentType type) {
    final id = const Uuid().v4();
    final component = FormComponent(
      id: id,
      type: type,
      label: _getDefaultLabel(type),
      placeholder: "Enter",
      boxWidth: switch (type) {
        FormComponentType.textField => 200.w,
        FormComponentType.textArea => 200.w,
        FormComponentType.checkbox => 25.w,
        FormComponentType.toggle => 100.w,
        FormComponentType.dropdown => 200.w,
        FormComponentType.datePicker => 200.w,
        FormComponentType.signaturePad => 250.w,
        FormComponentType.imagePlaceholder => 300.w,
        FormComponentType.divider => 1.w,
      },
    );

    setState(() {
      _components.add(component);
    });

    final index = _quillController.selection.baseOffset;
    _quillController.document.insert(index, BlockEmbed('form_component', id));
    _quillController.updateSelection(
      TextSelection.collapsed(offset: index + 1),
      ChangeSource.local,
    );
  }

  String _getDefaultLabel(FormComponentType type) {
    switch (type) {
      case FormComponentType.textField:
        return "First Name";
      case FormComponentType.textArea:
        return "Message";
      case FormComponentType.checkbox:
        return "Agree to terms";
      case FormComponentType.toggle:
        return "Notifications";
      case FormComponentType.dropdown:
        return "Select Country";
      case FormComponentType.datePicker:
        return "Date of Birth";
      case FormComponentType.signaturePad:
        return "Signature";
      case FormComponentType.imagePlaceholder:
        return "Profile Photo";
      case FormComponentType.divider:
        return "Divider";
    }
  }

  Future<void> _saveForm() async {
    if (_nameController.text.isEmpty) {
      _showError("Please enter a form name");
      return;
    }
    if (_quillController.document.isEmpty()) {
      _showError("Document is empty");
      return;
    }

    setState(() => _isSaving = true);
    try {
      final name = _formsController.getUniqueName(_nameController.text);
      final rawText = _deltaToRawText(_quillController.document.toDelta());

      final xFile = await PdfService.generateFormPdf(
        name,
        _components,
        documentText: rawText,
      );

      final template = FormTemplate(
        id: const Uuid().v4(),
        name: name,
        file: xFile,
        createdAt: DateTime.now(),
        isUserCreated: true,
      );

      await _formsController.saveForm(template);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError("Failed to save form: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _deltaToRawText(Delta delta) {
    final sb = StringBuffer();
    for (final op in delta.toList()) {
      if (op.isInsert) {
        if (op.data is String) {
          sb.write(op.data);
        } else if (op.data is Map &&
            (op.data as Map).containsKey('form_component')) {
          final id = (op.data as Map)['form_component'];
          final comp = _components.firstWhere(
            (c) => c.id == id,
            orElse: () => FormComponent(
              id: id,
              type: FormComponentType.textField,
              boxWidth: 100.w,
            ),
          );
          sb.write(" [[${comp.type.name}:$id]] ");
        }
      }
    }
    return sb.toString();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

class _PaletteItem {
  final FormComponentType type;
  final IconData icon;
  final String label;
  _PaletteItem({required this.type, required this.icon, required this.label});
}

class FormEmbedBuilder extends EmbedBuilder {
  final void Function(FormComponent) onChanged;
  final void Function(String) onDelete;

  FormEmbedBuilder({required this.onChanged, required this.onDelete});

  @override
  String get key => 'form_component';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final node = embedContext.node;
    final id = node.value.data;
    final state = context.findAncestorStateOfType<_FormBuilderScreenState>();
    if (state == null) return const SizedBox.shrink();

    final component = state._components.firstWhere(
      (c) => c.id == id,
      orElse: () => FormComponent(
        id: id,
        type: FormComponentType.textField,
        boxWidth: 100.w,
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onLongPress: () => _showEditDialog(context, component),
        child: _buildComponentWidget(context, component),
      ),
    );
  }

  Widget _buildComponentWidget(BuildContext context, FormComponent comp) {
    switch (comp.type) {
      case FormComponentType.textField:
        return SizedBox(
          width: comp.boxWidth,
          child: TextField(
            decoration: InputDecoration.collapsed(
              hintText: comp.placeholder,
              enabled: false,
              border: const UnderlineInputBorder(),
            ),
            onChanged: (val) => onChanged(comp.copyWith(value: val)),
          ),
        );
      case FormComponentType.textArea:
        return SizedBox(
          width: comp.boxWidth,
          child: TextField(
            maxLines: 3,
            decoration: InputDecoration.collapsed(
              hintText: comp.placeholder,
              enabled: false,
              border: const UnderlineInputBorder(),
            ),
            onChanged: (val) => onChanged(comp.copyWith(value: val)),
          ),
        );
      case FormComponentType.checkbox:
        return Checkbox(
          value: comp.value ?? false,
          onChanged: (val) => onChanged(comp.copyWith(value: val)),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        );
      case FormComponentType.toggle:
        return Transform.scale(
          scale: 0.7,
          child: Switch(
            value: comp.value ?? false,
            onChanged: (val) => onChanged(comp.copyWith(value: val)),
            padding: EdgeInsets.zero,
            inactiveThumbColor: CustomColors.white,
          ),
        );
      case FormComponentType.dropdown:
        return DropdownButton<String>(
          value: comp.value,
          hint: Text(comp.placeholder),
          items: comp.options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => onChanged(comp.copyWith(value: val)),
        );
      case FormComponentType.datePicker:
        return const Text('__/__/____');
      case FormComponentType.signaturePad:
        return Row(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            IntrinsicWidth(
              child: Container(
                width: comp.boxWidth.w,
                height: 60.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    "Signature Pad (Click to draw)",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        );
      case FormComponentType.imagePlaceholder:
        return Container(
          width: comp.boxWidth.w,
          height: comp.boxWidth.w,
          color: Colors.grey[200],
          child: const Icon(Icons.add_a_photo, color: Colors.grey),
        );
      case FormComponentType.divider:
        return const Divider(thickness: 2);
    }
  }

  void _showEditDialog(BuildContext context, FormComponent comp) {
    final labelController = TextEditingController(text: comp.label);
    final placeholderController = TextEditingController(text: comp.placeholder);
    final optionsController = TextEditingController(
      text: comp.options.join(', '),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit ${comp.type.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.h,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: "Label"),
            ),
            TextField(
              controller: placeholderController,
              decoration: const InputDecoration(labelText: "Placeholder/Text"),
            ),
            TextFormField(
              initialValue: '${comp.boxWidth}',
              decoration: const InputDecoration(labelText: "Width"),
              onChanged: (value) {
                final width = double.tryParse(value);
                if (width != null) {
                  log('Updated: $width');
                  comp = comp.copyWith(boxWidth: width);
                }
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            if (comp.type == FormComponentType.dropdown)
              TextField(
                controller: optionsController,
                decoration: const InputDecoration(
                  labelText: "Options (comma separated)",
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              onDelete(comp.id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onChanged(
                comp.copyWith(
                  label: labelController.text,
                  placeholder: placeholderController.text,
                  options: optionsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
