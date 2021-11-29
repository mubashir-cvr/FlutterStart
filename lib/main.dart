import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'FriendlyChat',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FriendlyChat'),
        ),
        body: _buildTextComposer(),
      ),
    ),
  );
}


final _textController = TextEditingController();


Widget _buildTextComposer() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
   child: Row(                
      children: [              
        Flexible(              
          child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            decoration:
                const InputDecoration.collapsed(hintText: 'Send a message'),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => _handleSubmitted(_textController.text)), 
        ),                     
      ],                       
    ),         
  );
}

void _handleSubmitted(String text) {
  _textController.clear();
}



// Flutter dev part 1 to 2 Start 
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];                  // wrod pair list from the external package
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random(); // Delete these... 
    //return Text(wordPair.asPascalCase); // ... two lines.

    return Scaffold (                     // Add from here... 
      appBar: AppBar(
        title: Text('Startup Name Generator'), actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );                                      // ... to here.
  }



    void _pushSaved() {
    Navigator.of(context).push(
      // Add lines from here...
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[Text("Nothing to display")];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ), // ...to here.
    );
  }


  
   Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(    
      alreadySaved ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved ? Colors.red : null,
      semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      
    ),
    onTap: () {       
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else { 
          _saved.add(pair); 
        } 
      });
    },   
    );
  }
   Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      // The itemBuilder callback is called once per suggested 
      // word pairing, and places each suggestion into a ListTile
      // row. For even rows, the function adds a ListTile row for
      // the word pairing. For odd rows, the function adds a 
      // Divider widget to visually separate the entries. Note that
      // the divider may be difficult to see on smaller devices.
      itemBuilder: (BuildContext _context, int i) {
        // Add a one-pixel-high divider widget before each row 
        // in the ListView.
        if (i.isOdd) {
          return Divider();
        }

        // The syntax "i ~/ 2" divides i by 2 and returns an 
        // integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings 
        // in the ListView,minus the divider widgets.
        final int index = i ~/ 2;
        // If you've reached the end of the available word
        // pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the 
          // suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }
}

// Flutter dev part 1 to 2 End 