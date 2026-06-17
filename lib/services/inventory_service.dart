import '../models/requests/add_inventory_request.dart';
import '../models/responses/add_inventory_response.dart';
import '../models/responses/catalog_response.dart';
import '../models/responses/clinic_products_response.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class InventoryService {
  Future<List<CatalogItem>> getCatalog() async {
    final json = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.catalog,
      requestType: RequestType.get,
    );
    final response = CatalogResponse.fromJson(json);
    if (!response.status) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  Future<List<ClinicProduct>> getClinicProducts() async {
    final json = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.clinicProducts,
      requestType: RequestType.get,
    );
    final response = ClinicProductsResponse.fromJson(json);
    if (!response.status) {
      throw Exception(response.message);
    }
    return response.data ?? [];
  }

  Future<ClinicProduct> addInventoryItem(AddInventoryRequest request) async {
    final json = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.clinicProducts,
      requestType: RequestType.post,
      requestBody: request,
    );
    final response = AddInventoryResponse.fromJson(json);
    if (!response.status || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }
}
