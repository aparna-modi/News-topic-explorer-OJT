//importing material.dart
//for importing all flutter material UI tools
import 'package:flutter/material.dart';
//import '/Users/aparnamodi/StudioProjects/tes_ojt_project/lib/features/article/data/article_model.dart';
// import '../../data/article_repository.dart';
import '../../../article/data/article_model.dart';
import '../../../article/data/article_repository.dart';
// import '../features/article/data/article_model.dart';
// import '../features/article/data/article_repository.dart';

//stateful widgets
// because screen updates and rebuilds it self when we search something and click on go
class SearchScreen extends StatefulWidget {
  //constuctor
  const SearchScreen({super.key});

  @override


  //setting state of search screen
  // createState() -  to set the initial state of the screen
  // State<Whose state to be set>
  State<SearchScreen> createState() => _SearchScreenState();

}

class _SearchScreenState extends State<SearchScreen> {
  // 1. FORM & CONTROLLERS
  // controllers and key
  //using global key for form validation
  //checks whether the text field contains valid data
  // _formKey : asdf
  final _formKey = GlobalKey<FormState>(); // For Validation
  final _searchController = TextEditingController(); // For Input Text

  // 2. STATE VARIABLES
  List<ArticleModel> _articles = [];
  bool _isLoading = false; //setting isLoading to false
  //to show the status of the search that nothing is loading nor or not searching wnything now
  String _statusMessage = "Type a topic to search news";//initial text when not searched anything

  // 3. SEARCH LOGIC
  void _performSearch() async {
    // A. VALIDATION (Requirement 1: Forms + Validation)
    // checking for validation if global key is valid
    if (_formKey.currentState!.validate()) {

      // Update UI to loading
      setState(() {
        _isLoading = true;
        _statusMessage = "Searching...";
      });

      try {
        // B. API CALL (Requirement 2: API Integration)
        final results = await ArticleRepository().searchArticles(_searchController.text);


        //setting state of the search screen
        setState(() {
          //is loading to false
          //when loading has been finished and we need to show the results
          _articles = results;
          _isLoading = false;
          //if results are empty
          //that is uba
          if (results.isEmpty) {
            //nothing to be loaded as keyword in invalid
            //since no news found
            _statusMessage = "No news found for this topic.";
          }
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          //when we are unable to fetch news and there is a error
          //displaying status message for error
          _statusMessage = "Error: Could not fetch news.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar with search news text
      appBar: AppBar(title: const Text("Search News")),
      body: Padding(
        //setting a padding
        padding: const EdgeInsets.all(16.0),
        // using column to stack things vertically
        child: Column(
          children: [

            // --- SECTION 1: THE FORM ---
            Form(
              //formKey = what we inputed in the text field
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: "Search Topic (e.g. Bitcoin)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      // VALIDATION LOGIC
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a keyword'; // Error message
                        }
                        return null; // Valid
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text("GO"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECTION 2: THE RESULTS (State Management) ---
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _articles.isEmpty
                  ? Center(child: Text(_statusMessage, style: const TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: article.urlToImage != null
                          ? Image.network(
                        article.urlToImage!,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 50),
                      )
                          : const Icon(Icons.article, size: 50),
                      title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(article.publishedAt ?? "", style: const TextStyle(fontSize: 12)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}