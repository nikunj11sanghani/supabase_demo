import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HelperDialog extends StatefulWidget {
  final bool isForAdd;
  final ValueNotifier<bool> isLoading;
  final TextEditingController dataController;
  final Object? id;

  const HelperDialog(
      {super.key,
      required this.isForAdd,
      required this.isLoading,
      required this.dataController,
      this.id});

  @override
  State<HelperDialog> createState() => _HelperDialogState();
}

class _HelperDialogState extends State<HelperDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    hintText: widget.isForAdd
                        ? "Add Data To Data Base"
                        : "Update Data To Data Base"),
                controller: widget.dataController,
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Please Enter Data first";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: widget.isForAdd
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            widget.isLoading.value = false;
                            await Supabase.instance.client
                                .from('important_notes')
                                .insert(
                                    {'data': widget.dataController.text}).then(
                              (value) {
                                widget.dataController.clear();
                                widget.isLoading.value = true;
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        }
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            widget.isLoading.value = false;
                            await Supabase.instance.client
                                .from('important_notes')
                                .update({'data': widget.dataController.text})
                                .eq('id', widget.id!)
                                .then(
                                  (value) {
                                    widget.dataController.clear();
                                    widget.isLoading.value = true;
                                    Navigator.of(context).pop();
                                  },
                                );
                          }
                        },
                  child: Text(widget.isForAdd ? "Add Data" : "Update Data")),
              ValueListenableBuilder(
                valueListenable: widget.isLoading,
                builder: (context, value, child) {
                  return value
                      ? const SizedBox.shrink()
                      : const CircularProgressIndicator();
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
