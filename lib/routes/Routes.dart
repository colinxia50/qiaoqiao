import 'package:flutter/material.dart';
import '../pages/Tabs.dart';
import '../pages/tabs/AticleShow.dart';
import '../pages/Tabs/RedEnvelope.dart';

  final routes = {
          '/':(context,{arguments})=>Tabs(),
          '/AticleShow':(context,{arguments})=>AticleShow(arguments:arguments),
          '/RedEnvelope':(context,{arguments})=>RedEnvelope(),
  };

   var onGenerateRoute =  (RouteSettings settings){
    //args=ModalRoute.of(context).settings.arguments;
          final String name = settings.name;
          final Function pageContenBuilder = routes[name];
          if(pageContenBuilder !=null){
            if(settings.arguments !=null){
              final Route route = MaterialPageRoute(
                builder: (context)=>
                pageContenBuilder(context,arguments:settings.arguments));
                return route;
            }else{
              final Route route = MaterialPageRoute(
                builder: (context)=>pageContenBuilder(context)
              );
              return route;
            }

          }

        };