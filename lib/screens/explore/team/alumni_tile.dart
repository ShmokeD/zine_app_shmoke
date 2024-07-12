import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zineapp2023/providers/dictionary/team_dict.dart';
import 'package:zineapp2023/screens/dashboard/view_models/dashboard_vm.dart';
import 'package:zineapp2023/theme/color.dart';

class AlumniTile extends StatelessWidget {
  final Team alumni;
  final String year;
  const AlumniTile({super.key, required this.alumni, required this.year});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: alumni.name!,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AlumniPage(
                        alumni: alumni,
                        year: year,
                      ),
                  opaque: false)),
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.asset(
                        fit: BoxFit.cover,
                        'assets/images/$year/${alumni.image}.webp',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Center(
                    child: Text(
                      alumni.name!,
                      style: const TextStyle(
                          fontSize: 18.0,
                          color: textDarkBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      alumni.branch!,
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: textDarkBlue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlumniPage extends StatelessWidget {
  const AlumniPage({super.key, required this.alumni, required this.year});
  final Team alumni;
  final String year;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Consumer<DashboardVm>(builder: (context, dashboardVm, _) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
          child: Hero(
            tag: alumni.name!,
            child: TapRegion(
              onTapOutside: (event) => Navigator.pop(context),
              child: Card(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                        child: Image.asset(
                          fit: BoxFit.cover,
                          'assets/images/$year/${alumni.image}.webp',
                        ),
                      ),
                    ),
                    const Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    Center(
                      child: Text(
                        alumni.name!,
                        style: const TextStyle(
                            fontSize: 28.0,
                            color: textDarkBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(alumni.bio!,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              color: textColor,
                            )),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                final link =
                                    Uri(scheme: 'https', path: alumni.linkedIn);
                                dashboardVm.launchUrl(link.toString());
                              },
                              style: ElevatedButton.styleFrom(
                                iconColor: textDarkBlue,
                              ),
                              child: const Icon(FontAwesomeIcons.linkedin)),
                          ElevatedButton(
                              onPressed: () {
                                final email =
                                    Uri(scheme: 'mailto', path: alumni.email);
                                dashboardVm.launchUrl(email.toString());
                              },
                              style: ElevatedButton.styleFrom(
                                iconColor: textDarkBlue,
                              ),
                              child: const Icon(Icons.email))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
