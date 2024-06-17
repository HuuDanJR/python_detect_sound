import 'package:bingo_game/hive/hive_controller.dart';
import 'package:bingo_game/hive/model/setting_model.dart';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/page/pickup/bloc/pickup_bloc.dart';

class PickUpPage extends StatelessWidget {
  const PickUpPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => PickupBloc()..add(GeneratePickups()),
      child: 
      BlocListener<PickupBloc, PickupState>(
        listener: (context, state) {
          debugPrint('${state.selectedPickups.length}:${state.selectedPickups}');
          if(state.selectedPickups.isEmpty){
            final settingModel  = SettingModel(roundInitial: [], timeDuration: ConfigFactory.timer_duration_time, totalRound: ConfigFactory.LIST_LENGTH);
            HiveController().saveSetting(settingModel);
          }else{
            final settingModel  = SettingModel(roundInitial: state.selectedPickups.toList(), timeDuration: ConfigFactory.timer_duration_time, totalRound: ConfigFactory.LIST_LENGTH);
            HiveController().updateSetting(settingModel);
          }
      },
      child:Container(
        alignment: Alignment.center,
        width: width / 3,
        height: height / 2.5,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<PickupBloc, PickupState>(
                builder: (context, state) {
                  if (state.pickups.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                    ),
                    itemCount: state.pickups.length,
                    itemBuilder: (context, index) {
                      final pickup = state.pickups[index];
                      final isSelected = state.selectedPickups.contains(pickup);
                      return GestureDetector(
                        onTap: () {
                          context.read<PickupBloc>().add(TogglePickupSelection(pickup));
                          // debugPrint('PickUpPage: ${state.selectedPickups} length: ${state.selectedPickups.length}');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              pickup.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            
          ],
        ),
      ),)
    );
  }
}