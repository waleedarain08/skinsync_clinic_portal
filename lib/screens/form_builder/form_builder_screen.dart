import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/form_component.dart';
import '../../models/form_template.dart';
import '../../view_models/forms_controller.dart';
import '../../services/locator.dart';
import '../../services/pdf_service.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';

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
  final FormsController _formsController = locator<FormsController>();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onWillPop(_, _) async {
    if (_components.isEmpty) return;

    await showDialog<bool>(
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
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _onWillPop,
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
        type: FormComponentType.textLabel,
        icon: Icons.title,
        label: "Text Label",
      ),
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
      _PaletteItem(
        type: FormComponentType.pageBreak,
        icon: Icons.insert_page_break,
        label: "Page Break",
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return DragTarget<FormComponentType>(
          onAcceptWithDetails: (details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localOffset = renderBox.globalToLocal(details.offset);

            // Adjust localOffset by the padding of the canvas container
            _addComponentAt(
              details.data,
              localOffset.dx - 24.w,
              localOffset.dy - 24.w,
            );
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(24.w),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: 500.w,
                    height: 700
                        .h, // Fixed height for visual consistency as a "page"
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
                    child: _components.isEmpty
                        ? _buildEmptyCanvas()
                        : Stack(
                            children: _components
                                .map((c) => _buildPositionedComponent(c))
                                .toList(),
                          ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyCanvas() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_to_photos_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("Drag and drop components here", style: CustomFonts.grey14w500),
        ],
      ),
    );
  }

  Widget _buildPositionedComponent(FormComponent component) {
    return Positioned(
      left: component.dx,
      top: component.dy,
      width: component.width,
      height: component.height,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            component.dx += details.delta.dx;
            component.dy += details.delta.dy;

            // Boundary checks
            if (component.dx < 0) component.dx = 0;
            if (component.dy < 0) component.dy = 0;
            if (component.dx + component.width > 500.w) {
              component.dx = 500.w - component.width;
            }
            if (component.dy + component.height > 700.h) {
              component.dy = 700.h - component.height;
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomColors.purple.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              _buildComponentPreview(component),
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.blue,
                      ),
                      onPressed: () => _editProperties(component),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red,
                      ),
                      onPressed: () =>
                          setState(() => _components.remove(component)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComponentPreview(FormComponent component) {
    switch (component.type) {
      case FormComponentType.textLabel:
        return Center(
          child: Text(
            component.label,
            style: TextStyle(
              fontSize: component.fontSize,
              fontWeight: component.isBold
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontStyle: component.isItalic
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        );
      case FormComponentType.textField:
      case FormComponentType.textArea:
      case FormComponentType.dropdown:
      case FormComponentType.datePicker:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (component.label.isNotEmpty)
                Text(component.label, style: CustomFonts.black12w600),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    component.placeholder,
                    style: CustomFonts.grey12w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      case FormComponentType.checkbox:
      case FormComponentType.toggle:
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                component.type == FormComponentType.checkbox
                    ? Icons.check_box_outline_blank
                    : Icons.toggle_off,
                color: CustomColors.purple,
              ),
              const SizedBox(width: 8),
              Text(component.label, overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      case FormComponentType.signaturePad:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gesture, color: CustomColors.lightGrey),
              Text(
                component.label.isNotEmpty ? component.label : "Signature",
                style: CustomFonts.grey12w400,
              ),
            ],
          ),
        );
      case FormComponentType.imagePlaceholder:
        return Center(
          child: Icon(Icons.image, color: Colors.grey[300], size: 32),
        );
      case FormComponentType.divider:
        return const Center(child: Divider());
      case FormComponentType.pageBreak:
        return Container(
          color: Colors.blue.withValues(alpha: 0.1),
          child: const Center(
            child: Text(
              "PAGE BREAK",
              style: TextStyle(fontSize: 10, color: Colors.blue),
            ),
          ),
        );
    }
  }

  void _addComponent(FormComponentType type) {
    _addComponentAt(type, 50, 50);
  }

  void _addComponentAt(FormComponentType type, double x, double y) {
    setState(() {
      _components.add(
        FormComponent(
          id: const Uuid().v4(),
          type: type,
          label: _getDefaultLabel(type),
          placeholder: "Enter ${type.name}...",
          dx: x,
          dy: y,
          width: _getDefaultWidth(type),
          height: _getDefaultHeight(type),
        ),
      );
    });
  }

  double _getDefaultWidth(FormComponentType type) {
    switch (type) {
      case FormComponentType.divider:
      case FormComponentType.pageBreak:
        return 460.w;
      case FormComponentType.signaturePad:
        return 200.w;
      default:
        return 200.w;
    }
  }

  double _getDefaultHeight(FormComponentType type) {
    switch (type) {
      case FormComponentType.textArea:
        return 100.h;
      case FormComponentType.divider:
      case FormComponentType.pageBreak:
        return 20.h;
      case FormComponentType.signaturePad:
        return 80.h;
      default:
        return 50.h;
    }
  }

  String _getDefaultLabel(FormComponentType type) {
    switch (type) {
      case FormComponentType.textLabel:
        return "Label Text";
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
        return "";
      case FormComponentType.pageBreak:
        return "";
    }
  }

  void _editProperties(FormComponent component) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _PropertiesPanel(
        component: component,
        onUpdate: () => setState(() {}),
      ),
    );
  }

  Future<void> _saveForm() async {
    if (_nameController.text.isEmpty) {
      _showError("Please enter a form name");
      return;
    }
    if (_components.isEmpty) {
      _showError("Add at least one component before saving");
      return;
    }

    setState(() => _isSaving = true);
    try {
      final name = _formsController.getUniqueName(_nameController.text);
      final file = await PdfService.generateFormPdf(name, _components);

      final template = FormTemplate(
        id: const Uuid().v4(),
        name: name,
        filePath: file.path,
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

class _PropertiesPanel extends StatefulWidget {
  final FormComponent component;
  final VoidCallback onUpdate;
  const _PropertiesPanel({required this.component, required this.onUpdate});

  @override
  State<_PropertiesPanel> createState() => _PropertiesPanelState();
}

class _PropertiesPanelState extends State<_PropertiesPanel> {
  late TextEditingController _labelController;
  late TextEditingController _placeholderController;
  late TextEditingController _optionsController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.component.label);
    _placeholderController = TextEditingController(
      text: widget.component.placeholder,
    );
    _optionsController = TextEditingController(
      text: widget.component.options.join(', '),
    );
    _widthController = TextEditingController(
      text: widget.component.width.toStringAsFixed(0),
    );
    _heightController = TextEditingController(
      text: widget.component.height.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _placeholderController.dispose();
    _optionsController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comp = widget.component;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit Properties", style: CustomFonts.black18w600),
            SizedBox(height: 16.h),

            // Positioning & Sizing
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(labelText: "Width"),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final double? value = double.tryParse(val);
                      if (value != null) {
                        setState(() => comp.width = value);
                        widget.onUpdate();
                      }
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    decoration: const InputDecoration(labelText: "Height"),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final double? value = double.tryParse(val);
                      if (value != null) {
                        setState(() => comp.height = value);
                        widget.onUpdate();
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            if (comp.type != FormComponentType.divider &&
                comp.type != FormComponentType.pageBreak)
              TextField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: "Label Text"),
                onChanged: (val) {
                  comp.label = val;
                  widget.onUpdate();
                },
              ),
            if (comp.type == FormComponentType.textField ||
                comp.type == FormComponentType.textArea)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: TextField(
                  controller: _placeholderController,
                  decoration: const InputDecoration(labelText: "Placeholder"),
                  onChanged: (val) {
                    comp.placeholder = val;
                    widget.onUpdate();
                  },
                ),
              ),
            if (comp.type == FormComponentType.textLabel) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  const Text("Font Size"),
                  Expanded(
                    child: Slider(
                      value: comp.fontSize,
                      min: 8,
                      max: 72,
                      onChanged: (val) {
                        setState(() => comp.fontSize = val);
                        widget.onUpdate();
                      },
                    ),
                  ),
                  Text(comp.fontSize.toInt().toString()),
                ],
              ),
              Row(
                children: [
                  FilterChip(
                    label: const Text("Bold"),
                    selected: comp.isBold,
                    onSelected: (val) {
                      setState(() => comp.isBold = val);
                      widget.onUpdate();
                    },
                  ),
                  SizedBox(width: 8.w),
                  FilterChip(
                    label: const Text("Italic"),
                    selected: comp.isItalic,
                    onSelected: (val) {
                      setState(() => comp.isItalic = val);
                      widget.onUpdate();
                    },
                  ),
                ],
              ),
            ],
            if (comp.type == FormComponentType.dropdown) ...[
              SizedBox(height: 12.h),
              TextField(
                controller: _optionsController,
                decoration: const InputDecoration(
                  labelText: "Options (comma separated)",
                ),
                onChanged: (val) {
                  comp.options = val.split(',').map((e) => e.trim()).toList();
                  widget.onUpdate();
                },
              ),
            ],
            if (comp.type == FormComponentType.signaturePad) ...[
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                initialValue: comp.boxHeight,
                decoration: const InputDecoration(labelText: "Box Height"),
                items: ['small', 'medium', 'large']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() => comp.boxHeight = val);
                  widget.onUpdate();
                },
              ),
            ],
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Center(child: Text("Done")),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
