import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/responses/clinic_products_response.dart';
import '../../utils/theme.dart';
import '../../view_models/product_view_model.dart';
import '../../view_models/session_view_model.dart';
import '../../view_models/treatment_view_model.dart';
import '../app_network_image.dart';
import '../build_textfield.dart';

class MaterialsStep extends ConsumerStatefulWidget {
  const MaterialsStep({super.key});

  @override
  ConsumerState<MaterialsStep> createState() => _MaterialsStepState();
}

class _MaterialsStepState extends ConsumerState<MaterialsStep> {
  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  String _formatUnitPlural(String unit) {
    if (unit.isEmpty) return 'Units';
    final lower = unit.toLowerCase();
    if (lower == 'unit' || lower == 'u') return 'Units';
    if (lower.contains('unit (u)')) return 'Units (U)';
    if (lower == 'syringe') return 'Syringes';
    if (lower == 'vial') return 'Vials';
    if (lower == 'bottle') return 'Bottles';
    if (lower == 'tube') return 'Tubes';
    if (lower == 'kit') return 'Kits';
    if (lower == 'pack') return 'Packs';
    if (lower == 'piece') return 'Pieces';
    if (lower.endsWith('s')) return unit;
    return '${unit}s';
  }

  Widget _buildProductSelector(
    BuildContext context,
    List<ClinicProduct> products,
    SessionViewModel viewModel,
    TreatmentState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Product from Inventory', style: context.fonts.black14w600),
        context.verticalSpace(10),
        DropdownButtonHideUnderline(
          child: DropdownButton2<ClinicProduct>(
            isExpanded: true,
            hint: Text("Select Product", style: context.fonts.grey14w400),
            items: products.map((p) {
              return DropdownMenuItem<ClinicProduct>(
                value: p,
                child: Text(
                  '${p.name ?? ''} (${p.unit ?? 'Unit'})',
                  style: context.fonts.black14w400,
                ),
              );
            }).toList(),
            onChanged: (p) {
              if (p != null) {
                viewModel.addProductUsage(
                  p.productId ?? 0,
                  p.name ?? '',
                  p.unit ?? 'Unit',
                );
              }
            },
            buttonStyleData: ButtonStyleData(
              height: context.h(55),
              padding: context.appEdgeInsets(horizontal: 16),
              decoration: BoxDecoration(
                color: CustomColors.softGrey,
                borderRadius: context.appBorderRadius(all: 10),
                border: Border.all(color: CustomColors.border),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: context.h(300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: context.appBorderRadius(all: 12),
              ),
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: TextEditingController(),
              searchInnerWidgetHeight: context.h(50),
              searchInnerWidget: Container(
                height: context.h(50),
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Search for a product...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value?.name?.toLowerCase().contains(
                      searchValue.toLowerCase(),
                    ) ??
                    false;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductUsageCard(
    BuildContext context,
    WidgetRef ref,
    int index,
    ProductUsageEntry entry,
    SessionViewModel viewModel,
    TreatmentState state,
  ) {
    final inventoryState = ref.watch(productViewModelProvider);
    final ClinicProduct? productData =
        inventoryState.clinicProducts.any((p) => p.productId == entry.productId)
        ? inventoryState.clinicProducts.firstWhere(
            (p) => p.productId == entry.productId,
          )
        : null;

    final imageUrl = productData?.image;
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              AppNetworkImage(
                imageUrl: hasValidImage ? imageUrl : '',
                width: 64,
                height: 64,
                borderRadius: BorderRadius.circular(8),
                fit: BoxFit.cover,
                errorIcon: Icons.broken_image,
                errorIconSize: 24,
              ),
              context.horizontalSpace(16),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.productName,
                      style: context.fonts.black14w700,
                      overflow: TextOverflow.ellipsis,
                    ),
                    context.verticalSpace(4),
                    Text(
                      'Unit: ${entry.unit}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                onPressed: () => viewModel.removeProductUsage(index),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Dosage',
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          child: BuildTextField(
                            label: 'Min Amount',
                            controller: entry.minQuantityController,
                            hintText: 'e.g. 10',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          child: BuildTextField(
                            label: 'Max Amount',
                            controller: entry.maxQuantityController,
                            hintText: 'e.g. 30',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            children: [
              Checkbox(
                value: entry.allowSubstitution,
                activeColor: CustomColors.purple,
                onChanged: (val) {
                  viewModel.updateProductUsageEntry(
                    index,
                    allowSubstitution: val ?? false,
                  );
                },
              ),
              context.horizontalSpace(8),
              Text(
                'Allow Product Substitution',
                style: context.fonts.black14w600,
              ),
            ],
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: 'Usage Notes (Optional)',
            controller: entry.notesController,
            hintText: 'Clinical instructions or restrictions...',
            maxLines: 2,
          ),
          context.verticalSpace(24),
          const Divider(),
          context.verticalSpace(16),
          Text('Product Consumption Range', style: context.fonts.black14w600),
          context.verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Min ${_formatUnitPlural(entry.unit)}',
                  controller: entry.minQuantityController,
                  hintText: '1',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(index, '');
                  },
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: BuildTextField(
                  label: 'Max ${_formatUnitPlural(entry.unit)}',
                  controller: entry.maxQuantityController,
                  hintText: '1',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(index, '');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    final inventoryState = ref.read(productViewModelProvider);
    final products = inventoryState.clinicProducts;

    if (products.isEmpty && !inventoryState.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(productViewModelProvider.notifier).getData();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionViewModelProvider);
    final treatmentState = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);
    final inventoryState = ref.watch(productViewModelProvider);
    final products = inventoryState.clinicProducts;

    // if (products.isEmpty && !inventoryState.loading) {
    //   Future.microtask(() => ref.read(inventoryProvider.notifier).getData());
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Inventory Products'),
        context.verticalSpace(8),
        Text(
          'Select specific products from inventory and define clinical usage rules.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),
        if (inventoryState.loading) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: CircularProgressIndicator(color: CustomColors.purple),
            ),
          ),
        ] else if (state.products.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'No inventory products available for selected category hierarchy.',
              style: context.fonts.grey14w400,
            ),
          ),
        ] else ...[
          _buildProductSelector(context, products, viewModel, treatmentState),
        ],
        if (state.productUsageEntries.isNotEmpty) ...[
          context.verticalSpace(32),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.productUsageEntries.length,
            separatorBuilder: (_, _) => context.verticalSpace(20),
            itemBuilder: (context, index) {
              return _buildProductUsageCard(
                context,
                ref,
                index,
                state.productUsageEntries[index],
                viewModel,
                treatmentState,
              );
            },
          ),
        ],
      ],
    );
  }
}
