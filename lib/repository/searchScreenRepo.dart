import '../models/search_item_model.dart';
import '../providers/SearchItemsProvider.dart';

class SearchScreenRepo{
final searchitems = SearchItemProvider();

Future<List<SearchtemModel>> searchItems(item_name) =>searchitems.fetchsearchItemProvider(item_name);

}