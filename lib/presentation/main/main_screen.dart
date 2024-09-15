import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/models/frequency.dart';
import 'package:natural_encoder/enums/encode_types.dart';
import 'package:natural_encoder/presentation/main/main_state.dart';
import 'package:natural_encoder/widgets/custom_button.dart';
import 'package:natural_encoder/widgets/graph.dart';
import 'main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {

  late MainBloc bloc;
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _encodedMessageController = TextEditingController();

  @override
  void initState() {
    bloc=MainBloc();

    WidgetsBinding.instance.addPostFrameCallback((_){
      bloc.showError=(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e}")));
      };
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (BuildContext context) {
            return bloc;
          },
          child: BlocBuilder<MainBloc,MainState>(
            bloc: bloc,
            builder: (context,state){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 40,),

                    _buildTopPanel(state),

                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 250),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Введите сообщение для шифрования',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(color: Colors.black),
                                )
                              ),
                              keyboardType: TextInputType.multiline,
                              minLines: 6,
                              maxLines: null,
                              onChanged: bloc.changeMessage,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Column(
                          children: [
                            InkWell(
                              onTap: (){
                                bloc.encode(_encodedMessageController);
                            
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.black12,
                                ),
                                child: const Center(child: Text('>>>>>>>'))),
                            ),
                            const SizedBox(height: 8,),
                            InkWell(
                              child: CustomButton(
                                enabled: state.type==EncodeTypes.caesar,
                                onTap: ()async{
                                  bloc.hackCypher(state.encodedMessage).then((value){
                                    _showDialog(value['message'],value['key']);
                                  });
                                },
                                title: 'Взломать',width: 100,),
                            )
                          ],
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 250),
                            child: TextFormField(
                              controller: _encodedMessageController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(color: Colors.black),
                                  )
                              ),
                              keyboardType: TextInputType.multiline,
                              minLines: 6,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),
                    CustomButton(onTap: (){
                      bloc.getFrequencyAnalys(state.encodedMessage,state.type);
                    }, title: 'Нарисовать график'),
                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Graph(
                                caesarFrequency: state.caesar_statics,
                                tritemiusFrequency: state.tritemius_statics,
                                twoArraysFrequency: state.two_arrays_statics,
                              ),
                              const SizedBox(height: 20,),
                              _buildInfoGraph(Colors.green, 'Оригинальный'),
                              _buildInfoGraph(Colors.redAccent, 'Метод Цезаря'),
                              _buildInfoGraph(Colors.blueAccent, 'Метод двумя массива'),
                              _buildInfoGraph(Colors.amber, 'Метод Тритемиуса'),

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
                                _buildStaticColumn(state.current_statics),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
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

  _showDialog(String message,String key){
    showDialog(context: context, builder: (context){
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16,),
              Text("Подобранный ключ : ${key}"),
              const SizedBox(height: 16,),
              Text("${message}"),
              const SizedBox(height: 16,),
              CustomButton(onTap: (){
                Navigator.pop(context);
              }, title: 'Ок'),
              const SizedBox(height: 16,),

            ],
          ),
        ),
      );
    });
  }

  _buildTopPanel(MainState state){
    return Wrap(
      children: [
        Container(
            constraints: const BoxConstraints(maxWidth: 200,minWidth: 100),
            child:  const Align(
                alignment: Alignment.center,
                child: Text("Выберите тип шифрования:"))),
        const SizedBox(width: 40,),

        Container(
          constraints: const BoxConstraints(maxWidth: 200,minWidth: 100),
          child: DropdownButton<EncodeTypes>(
            value: state.type,
            hint: const Text("Choose"),
            items: const [
              DropdownMenuItem(
                  value: EncodeTypes.caesar,
                  child: Text("Шифрование Цезаря")),
              DropdownMenuItem(
                  value: EncodeTypes.two_arrays,
                  child: Text("Двумя массивами")),
              DropdownMenuItem(
                  value: EncodeTypes.triremius,
                  child: Text("Метод Тритемиуса")),
            ],
            onChanged: (type){
              bloc.setEncodedType(type);
            },
          ),
        ),
        const SizedBox(width: 40,),

        Container(
          constraints: const BoxConstraints(maxWidth: 200,minWidth: 100),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _keyController,
            decoration: const InputDecoration(
                hintText: 'Введите ключ'
            ),
            onChanged: bloc.changeKey,
          ),
        ),
        const SizedBox(width: 40,),
        Container(
            constraints: const BoxConstraints(maxWidth: 200,minWidth: 100),
            child: InkWell(
              child: CustomButton(
                  onTap: (){
                    setState(() {
                      bloc.getRandomKey(_keyController);
                    });
                  },
                  title: 'Случайный'),
            ))
      ],
    );
  }

}
