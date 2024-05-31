import 'package:bingo_game/model/ball.dart';
import 'package:bingo_game/page/game/bloc/ball/ball_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BallAdminPage extends StatelessWidget {
  const BallAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  BallRecentPageView();
  }
}



class BallRecentPageView extends StatelessWidget {
   BallRecentPageView({super.key});

  final TextEditingController idController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ball App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<BallBloc, BallState>(
          listener: (context, state) {
            if (state is BallsLoaded) {
              // Handle the state change, for example, you can show a snackbar
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Balls list updated')),
              // );
            }
          },
          child: Column(
            children: <Widget>[
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Number'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  final int id = int.parse(idController.text);
                  final int number = int.parse(numberController.text);
                  final String tag = tagController.text;
                  final ball = Ball(
                    id: id,
                    number: number,
                    tag: tag,
                    isCreated: true,
                    status: 'default',
                  );
                  context.read<BallBloc>().add(AddBall(ball: ball));
                },
                child: const Text('Add Ball'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<BallBloc>().add(const RetrieveLatestBall());
                },
                child: const Text('Retrieve Latest Ball'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<BallBloc>().add(const RetrieveRecentBalls());
                },
                child: const Text('Retrieve recent Ball:5'),
              ),
              ElevatedButton(
                onPressed: () {
                  // To handle retrieving all balls, we should have an event that retrieves all balls
                  context.read<BallBloc>().add(const RetrieveAllBalls());
                },
                child: const Text('Retrieve All Balls'),
              ),
              Expanded(
                child: BlocBuilder<BallBloc, BallState>(
                  builder: (context, state) {
                    if (state is BallLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }  else if (state is BallsLoaded) {
                      return ListView.builder(
                        itemCount: state.balls.length,
                        itemBuilder: (context, index) {
                          final ball = state.balls[index];
                          return ListTile(
                            title: Text('Ball ID: ${ball.id} | Numbers ${ball.number}'),
                            subtitle: Text('Status: ${ball.status} : Tags ${ball.tag}'),
                          );
                        },
                      );
                    } else if (state is BallError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No balls'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// void _addBallOnInit() {
//     const int id = 111; // Provide your ID here
//     const int number = 111; // Provide your number here
//     const String tag = 'default'; // Provide your tag here
//     final ball = Ball(
//       id: id,
//       number: number,
//       tag: tag,
//       isCreated: true,
//       status: 'default',
//     );
//     context.read<BallBloc>().add(AddBall(ball: ball));
//   }
//   @override
//   void initState() {
//     _addBallOnInit();
//     super.initState();
//   }