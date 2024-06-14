import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/page/play/bloc/game_bloc.dart';
import 'package:bingo_game/widget/myprogress_circular.dart';
import 'package:bingo_game/widget/text.custom.dart';

class GamePlayedPage extends StatelessWidget {
  const GamePlayedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height / 10,
      // color: MyColor.grey_tab,
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state.status == GameStatus.initial) {
            return Center(child: myprogress_circular_size());
          } else if (state.status == GameStatus.success) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(StringFactory.padding0),
              itemCount: state.games.length,
              itemBuilder: (context, index) {
                final game = state.games[index];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: textCustom(color: MyColor.black_absulute,text: "GAME PROGRESS"),
                                  backgroundColor: MyColor.grey_BG_main,
                                  content: SizedBox(
                                      width: width /2 ,
                                      height: height / 2,
                                      child: ListView.builder(
                                        itemCount: state.games[index].round.length,
                                        itemBuilder: (context, i) {
                                          return Container(
                                            margin: const EdgeInsets.only(bottom:StringFactory.padding8),
                                            padding: const EdgeInsets.all(StringFactory.padding8),
                                            decoration: BoxDecoration(
                                              color:MyColor.white,
                                              border: Border.all(
                                                width: .5,
                                                color:MyColor.grey_tab,
                                              ),
                                              borderRadius: BorderRadius.circular(StringFactory.padding8)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                textCustom(color: MyColor.black_absulute,text: "#${i+1}"),
                                                textCustom(color: MyColor.black_absulute,text: "${state.games[index].round[i]}")
                                              ],
                                            ),
                                          );
                                        },
                                      )),
                                ));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding:
                              const EdgeInsets.all(StringFactory.padding16),
                          decoration: BoxDecoration(
                              // color:MyColor.white,
                              border: Border.all(color: MyColor.grey_tab),
                              borderRadius: BorderRadius.circular(
                                  StringFactory.padding8)),
                          child: textCustom(
                              text: game.gameName,
                              size: StringFactory.padding18,
                              color: MyColor.black_absulute)),
                    ),
                    const SizedBox(
                      width: StringFactory.padding8,
                    )
                  ],
                );
              },
            );
          } else if (state.status == GameStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Unknown error'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
