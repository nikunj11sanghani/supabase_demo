import 'package:flutter/material.dart';
import 'package:supabase_demo/widgets/helper_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  TextEditingController dataController = TextEditingController();

  final dataStream = Supabase.instance.client
      .from('important_notes')
      .stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: dataStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: IconButton(
                            onPressed: () async {
                              await Supabase.instance.client
                                  .from('important_notes')
                                  .delete()
                                  .eq('id', snapshot.data?[index]['id']);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return HelperDialog(
                                  dataController: dataController,
                                  isLoading: _isLoading,
                                  id: snapshot.data?[index]['id'],
                                  isForAdd: false,
                                );
                              },
                            );
                          },
                          tileColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          title: Text(snapshot.data![index]['data']),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return HelperDialog(
                  dataController: dataController,
                  isLoading: _isLoading,
                  isForAdd: true,
                );
              },
            );
          },
          child: const Icon(Icons.add, color: Colors.black, size: 35)),
    );
  }
}
