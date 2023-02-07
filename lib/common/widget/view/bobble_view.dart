import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:common_utils/common/base/base.dart';

class BobbleBean {
  //位置
  Offset postion;
  //颜色
  Color color;
  //运动的速度
  double speed;
  //角度
  double theta;
  //半径
  double radius;

  BobbleBean(this.postion,this.color,this.speed,this.theta,this.radius);
}

class BobbleView extends StatefulWidget {
  const BobbleView({Key? key}) : super(key: key);

  @override
  State<BobbleView> createState() => _BobbleViewState();
}

class _BobbleViewState extends State<BobbleView> with TickerProviderStateMixin {
  //创建的气泡保存集合
  final List<BobbleBean> _list = [];
  //随机数据
  final Random _random = Random(DateTime.now().microsecondsSinceEpoch);

  //气泡的最大半径
  double maxRadius = 100;

  //气泡动画的最大速度
  double maxSpeed = 0.7;

  //气泡计算使用的最大弧度（360度）
  double maxTheta = 2.0 * pi;

  //动画控制器
  late AnimationController _animationController;

  //流控制器
  final StreamController<double> _streamController = StreamController();

  late AnimationController _fadeAnimationController;

  @override
  void initState() {
    for (var i = 0; i < 20; i++) {
      //指定一个位置 每次绘制时还会修改
      //获取随机透明度的白色颜色
      //气泡运动速度
      //随机角度
      //随机半径
      BobbleBean bean = BobbleBean(const Offset(-1, -1),getRandonWhightColor(_random),_random.nextDouble() * maxSpeed,_random.nextDouble() * maxTheta,_random.nextDouble() * maxRadius);
      //集合保存
      _list.add(bean);
    }

    //动画控制器
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    //刷新监听
    _animationController.addListener(() {
      //流更新
      _streamController.add(0.0);
    });

    _fadeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //重复执行动画
        _animationController.repeat();
      }
    });
    //重复执行动画
    _fadeAnimationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        ///填充布局
        body: Stack(
          children: [
            //第一部分 第一层 渐变背景
            _buildBackground(),
            //第二部分 第二层 气泡
            _buildBubble(context),
            //第三部分 高斯模糊
            _buildBlure(),
          ],
        ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        //线性渐变
        gradient: LinearGradient(
          //渐变角度
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          //渐变颜色组
          colors: [
            Colors.lightBlue.withOpacity(0.3),
            Colors.lightBlueAccent.withOpacity(0.3),
            Colors.blue.withOpacity(0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context) {
    //使用Stream流实现局部更新
    return StreamBuilder<double>(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        //自定义画板
        return CustomPaint(
          //自定义画布
          painter: BobblePainter(_list, _random),
          child: Container(
            height: MediaQuery.of(context).size.height,
          ),
        );
      },
    );
  }

  Widget _buildBlure() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
      child: Container(
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }

  ///获取随机透明的白色
  Color getRandonWhightColor(Random random) {
    //0~255 0为完全透明 255 为不透明
    //这里生成的透明度取值范围为 10~200
    int a = random.nextInt(190) + 10;
    return Color.fromARGB(a, 255, 255, 255);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

}

class BobblePainter extends CustomPainter {

  //创建画笔
  final Paint _paint = Paint();
  //保存气泡的集合
  List<BobbleBean>? list;
  //随机数变量
  Random random;

  BobblePainter(this.list, this.random);

  @override
  void paint(Canvas canvas, Size size) {
    //每次绘制都重新计算位置
    list?.forEach((element) {
      //计算偏移
      var velocity = calculateXY(element.speed, element.theta);
      //新的坐标 微偏移
      var dx = element.postion.dx + velocity.dx;
      var dy = element.postion.dy + velocity.dy;
      //x轴边界计算
      if (element.postion.dx < 0 || element.postion.dx > size.width) {
        dx = random.nextDouble() * size.width;
      }
      //y轴边界计算
      if (element.postion.dy < 0 || element.postion.dy > size.height) {
        dy = random.nextDouble() * size.height;
      }
      //新的位置
      element.postion = Offset(dx, dy);
    });
    //循环绘制所有的气泡
    list?.forEach((element) {
      //画笔颜色
      _paint.color = element.color;
      //绘制圆
      canvas.drawCircle(element.postion, element.radius, _paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  ///计算坐标
  Offset calculateXY(double speed, double theta) {
    return Offset(speed * cos(theta), speed * sin(theta));
  }

}

