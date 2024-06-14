import 'package:bingo_game/APIs/service_api.dart';
import 'package:bingo_game/page/admin/switch/bloc/switch_bloc.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/socket/socket_manager.dart';

class SwitchButton extends StatelessWidget {
  SocketManager socketManager = SocketManager();
  final service_api = ServiceAPIs();
  

  SwitchButton({super.key, required this.socketManager});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchBloc, SwitchState>(
      builder: (context, state) {
        if (state is SwitchOn) {
          print("status = true");
          socketManager.eventChangeDisplay();
          
        } else if (state is SwitchOff) {
          print("status = false");
          socketManager.eventChangeDisplay();
          
        }
        return Container(
          // padding: EdgeInsets.all(StringFactory.padding),
          // decoration: BoxDecoration(
            // color:MyColor.grey_tab,
            // borderRadius: BorderRadius.circular(StringFactory.padding)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch.adaptive(
                value: state is SwitchOn,
                onChanged: (value) {
                  context.read<SwitchBloc>().add(ToggleSwitch());
                },
              ),
              Text(
                state is SwitchOn
                    ? 'Image/Video Display'
                    : 'Image/Video Display',
              )
            ],
          ),
        );
      },
    );
  }
}
