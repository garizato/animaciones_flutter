import 'package:flutter/material.dart';
import 'dart:math' as Math;

class AnimacionesPage extends StatefulWidget {
  @override
  _AnimacionesPageState createState() => _AnimacionesPageState();
}

class _AnimacionesPageState extends State<AnimacionesPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> animations = {
      "rotacion": {"begin": 0.0, "end": 2 * Math.pi, "curve": Curves.easeOut},
      "opacidad": {"begin": 0.1, "end": 1, "curve": Interval(0, 0.25)}
    };

    return Scaffold(
      body: Center(
        child: WidgetAnimado(_Rectangulo(), 4000, animations),
        //child: WidgetAnimado(Text('GERARDO'), 4000),
      ),
    );
  }
}

class WidgetAnimado extends StatefulWidget {
  Widget _widget;
  int _duration;
  Map<String, dynamic> _animations;

  WidgetAnimado(Widget widget, int duration, Map<String, dynamic> animations) {
    this._widget = widget;
    this._duration = duration;
    this._animations = animations;
  }

  @override
  _WidgetAnimadoState createState() =>
      _WidgetAnimadoState(_widget, _duration, _animations);
}

class _WidgetAnimadoState extends State<WidgetAnimado>
    with SingleTickerProviderStateMixin {
  Widget _widget;
  int _duration;
  Map<String, dynamic> _animations;

  _WidgetAnimadoState(widget, duration, animations) {
    this._widget = widget;
    this._duration = duration;
    this._animations = animations;
  }

  AnimationController controller;
  Animation<double> rotacion;
  Animation<double> opacidad;
  Animation<double> opacidadOut;
  Animation<double> moverDerecha;
  Animation<double> agrandar;

  @override
  void initState() {
    controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));

    if (_animations.containsKey("rotacion")) {
      final _rotacion = _animations['rotacion'];
      final Cubic _curve = _rotacion['curve'];

      rotacion = Tween(
              begin: double.parse(_rotacion['begin'].toString()),
              end: double.parse(_rotacion['end'].toString()))
          .animate(CurvedAnimation(parent: controller, curve: _curve));
    }

    if (_animations.containsKey("opacidad")) {
      final _opacidad = _animations['opacidad'];
      final Interval _interval = _opacidad['curve'];
      opacidad = Tween(begin: 0.1, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: _interval),
      );
    }

    opacidadOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Interval(0.75, 1.0)),
    );
    moverDerecha = Tween(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    agrandar = Tween(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    //opacidad = Tween(begin: 0.1, end: 1.0).animate(controller);

    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.reset();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();

    return AnimatedBuilder(
        animation: controller,
        child: _widget,
        //child: Text('Gerardo'),
        builder: (BuildContext context, Widget child) {
          //print(rotacion.value);
          return Transform.translate(
            offset: Offset(moverDerecha.value, 0),
            child: Transform.rotate(
              angle: rotacion.value,
              child: Opacity(
                opacity: opacidad.value - opacidadOut.value,
                child: Transform.scale(
                  scale: agrandar.value,
                  child: child,
                ),
              ),
            ),
          );
        });
  }
}

class _Rectangulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(color: Colors.blue),
    );
  }
}
