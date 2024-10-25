import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natural_encoder/presentation/hill/hill_bloc.dart';
import 'package:natural_encoder/widgets/custom_button.dart';

import '../../constans.dart';
import '../../domain/file_services/file_service.dart';
import '../../domain/models/frequency.dart';
import '../../widgets/graph.dart';
import '../../widgets/hill_graph.dart';
import 'hill_state.dart';

class HillScreen extends StatefulWidget {
  const HillScreen({super.key});

  @override
  State<HillScreen> createState() => _HillScreenState();
}

late TextEditingController _alphaberController;
late TextEditingController _messageController;
late TextEditingController _encodedMessageController;
late TextEditingController _fragmentDecodedController;
late TextEditingController _originalFragmentController;
late TextEditingController _fromController;
late TextEditingController _toController;

class _HillScreenState extends State<HillScreen> {

  int? currentArraySize = null;

  @override
  void initState() {
    _alphaberController = TextEditingController();
    _messageController = TextEditingController();
    _encodedMessageController = TextEditingController();
    _fragmentDecodedController = TextEditingController();
    _originalFragmentController = TextEditingController();
    _fromController = TextEditingController();
    _toController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: BlocProvider(
          create: (_) {
            return HillBloc();
          },

          child: BlocBuilder<HillBloc,HillState>(
            builder: (BuildContext context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
/*                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _alphaberController,
                          ),
                        ),
                        const SizedBox(width: 20,),
                        CustomButton(onTap: (){}, title: 'Подтведить')
                      ],
                    ),*/

                    _buildTopForm(context,state),
                    const SizedBox(height: 16,),
                    _buildArray(state.array,context),
                    const SizedBox(height: 16,),
                    Text("${state.errorMessage ?? ""}",style: TextStyle(color: Colors.red,fontSize: 16),),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        CustomButton(onTap: (){
                          _pickFile(context.read<HillBloc>());
                        }, title: 'Загрузить файл'),
                        const SizedBox(width: 20,),
                        CustomButton(onTap: (){
                          _saveFile(state.decodedMessage ?? "");
                        }, title: 'Сохранить файл'),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    
                                  )
                                )
                              ),
                              controller: _messageController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 6,
                              onChanged: (v){
                                context.read<HillBloc>().changeMessage(v);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,

                                      )
                                  )
                              ),
                              controller: _encodedMessageController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 6,
                              onChanged: (v){
                                context.read<HillBloc>().changeDecodedMessage(v);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(onTap: (){
                            context.read<HillBloc>().encode(_messageController.text,_encodedMessageController);
                          }, title: "Закодировать"),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: CustomButton(onTap: ()async{
                            context.read<HillBloc>().decodeMessage(state.decodedMessage ?? "").then((value){
                              _showDialog(context,value);
                            });
                          }, title: "Расшифровать"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    CustomButton(onTap: ()async{
                      context.read<HillBloc>().hack(fragment:_originalFragmentController.text,
                        decodedMessage:  _fragmentDecodedController.text,
                        fromString: _fromController.text,
                        toString: _toController.text,)?.then((value){
                        print("value? ${value}");
                        _showKeyDialog(context, value ?? []);
                      });
                    }, title: 'Попробовать взломать'),
                    const SizedBox(height: 16,),
/*                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _fragmentDecodedController,
                                decoration: InputDecoration(
                                  hintText: "Фрагмент защифрованного текста"
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _originalFragmentController,
                                decoration: InputDecoration(
                                    hintText: "Фрагмент оригинального текста"
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16,),
                        Text('или'),
                        const SizedBox(width: 16,),
                        Container(
                          child: Row(
                            children: [
                              Text('c'),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _fromController,
                                ),
                              ),
                              Text('до'),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _toController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16,),
                        CustomButton(onTap: ()async{
                          context.read<HillBloc>().hack(fragment:_originalFragmentController.text,
                              decodedMessage:  _fragmentDecodedController.text,
                              fromString: _fromController.text,
                              toString: _toController.text,)?.then((value){
                                print("value? ${value}");
                                _showKeyDialog(context, value ?? []);
                          });
                        }, title: 'Попробовать взломать')
                      ],
                    ),*/
                    const SizedBox(height: 16,),
                    Text("${state.hackErrorMessage ?? ""}",style: TextStyle(fontSize: 16,color: Colors.red),),
                    _buildStatisticsGraph(state),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildTopForm(BuildContext context,HillState state){
    return Row(
      children: [
        Expanded(
          child: DropdownButton<int>(
            value: currentArraySize,
            hint: const Text("Выберите размер матрицы"),
            items: const [
              DropdownMenuItem(
                  value: 2,
                  child: Text("2")),
              DropdownMenuItem(
                  value: 3,
                  child: Text("3")),
              DropdownMenuItem(
                  value: 4,
                  child: Text("4")),
              DropdownMenuItem(
                  value: 5,
                  child: Text("5")),
              DropdownMenuItem(
                  value: 6,
                  child: Text("6")),

            ],
            onChanged: (sizeArray){
              setState(() {
                currentArraySize=sizeArray;
              });
              context.read<HillBloc>().setArraySize(sizeArray ?? 2);
            },
          ),
        ),
      const SizedBox(width: 16,),
      Expanded(child: CustomButton(onTap: (){
        setState(() {
          context.read<HillBloc>().randomArray(state.array);

        });
      }, title: "Задать случайный массив"))
      ],
    );
  }


  Widget _buildArray(List<List<int>> array,BuildContext context){
    return Column(
      children: [
        for(int i=0;i<array.length;i++)...[
          Row(
            children: [
              for(int j=0;j<array[i].length;j++)...[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "${array[i][j]}",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onChanged: (v){
                      context.read<HillBloc>().changeArray(i, j, v, array);
                    },
                  ),
                )
              ]
            ],
          )
        ]
      ],
    );
  }


  _showDialog(BuildContext context,Map<String,dynamic> result){
    return showDialog(context: context, builder: (context){
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Расшифрованное сообщение"),
                Text("${result['message'] ?? ""}"),
              ],
            ),
          ),
        ),
      );
    });
  }

  _showKeyDialog(BuildContext context,List<List<int>> array,){
    return showDialog(context: context, builder: (context){
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(array.isEmpty)
                  Text("Не удалось взломать"),
                for(var row in array)...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for(var colmn in row)...[
                        Text("${colmn}",style: TextStyle(fontSize: 16),),
                        const SizedBox(width: 20,),
                      ],
                      const SizedBox(height: 20,),
                    ],
                  )
                ]
              ],
            ),
          ),
        ),
      );
    });
  }


  _buildStatisticsGraph(HillState state){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              HillGraph(
                hillFrequency: state.hillFrequency,
              ),
              const SizedBox(height: 20,),
              _buildInfoGraph(Colors.green, 'Оригинальный'),
              _buildInfoGraph(Colors.redAccent, 'Метод шифровки Хилла'),

            ],
          ),
        ),
        const SizedBox(width: 50,),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildStaticColumn(Alphabets.russianAlphabetFrequencies),

                const SizedBox(width: 30,),
                _buildStaticColumn(state.hillFrequency),
              ],
            ),
          ),
        )

      ],
    );
  }


  _buildInfoGraph(Color color,String text){
    return Row(
      children: [
        Container(
          width: 50,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 10,),
        Text(" --> ${text}"),
      ],
    );
  }

  Widget _buildStaticColumn(List<Frequency> list){
    return Column(
      children: [

        const Row(
          children: [
            SizedBox(
              child: Text("Буква"),
              width: 60,
            ),
            SizedBox(
                width: 100,
                child: Text("Частота использования")),
          ],
        ),
        Container(color: Colors.black,height: 1,width: 160,),
        for(var item in list)...[
          Row(
            children: [
              SizedBox(
                  width: 60,
                  child: Text("${item.character}")),
              SizedBox(
                  width: 100,
                  child: Text("${item.frequencyOfUse.toStringAsFixed(3)}")),
            ],
          ),
          Container(color: Colors.black,height: 1,width: 160,),
        ]
      ],
    );
  }


  _pickFile(HillBloc bloc)async{
    FileService fileService = FileService();
    final message = await fileService.pickFile();
    _messageController.text = message;
    bloc.changeMessage(message);
  }

  _saveFile(String text)async{
    FileService fileService = FileService();
    await fileService.saveFile(text);
  }


}
