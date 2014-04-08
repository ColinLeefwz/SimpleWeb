//定时器变量
    var tidck =null;					//存放图片的容器
    var can;							//画布
    var ctx;							//骰子每次的点数的数组
    var ranSum = 0;						//骰子变化次数
    var count = 0;						//圆点的坐标
    var _canvas = document.getElementById('canvas');
    var _p = document.getElementsByTagName('p')[0];
	
    var pointCoordinates = [
		[40,40],
		[[20,20],[60,60]],
		[[20,20],[40,40],[60,60]],
		[[20,20],[20,60],[60,20],[60,60]],
		[[20,20],[20,60],[40,40],[60,20],[60,60]],
		[[20,20],[20,40],[20,60],[60,20],[60,40],[60,60]]
	];									//单个骰子的点数

    var diceCoordinates = [
		[10,10],
		[120,10],
		[230,10],
		[10,120],
		[120,120],
		[230,120]
	];									//骰子的坐标

    window.onload = function(){
        can = document.getElementById('can');
        ctx = can.getContext("2d");
        loadCoordinates();				//初始化骰子
        ctop();

        document.getElementById('btnStart').onclick = function(){
            _p.style.display = 'none';
            this.disabled=true;
			count = 0;
			loadCoordinates();			//初始化骰子
			tidck = setInterval(drawCoordinates,50);                 
        };
    }

    //初始化骰子
    function loadCoordinates(){
        ctx.clearRect(0,0,can.width,can.height);//在给定区域内清空一个矩形
        for(var i=0,j=0;i<diceCoordinates.length;i++,j++){
            ctx.fillStyle = '#2ea8e5';			//定义填充的颜色
            ctx.fillRect(diceCoordinates[i][0],diceCoordinates[i][1],80,80);  //fillRect(x,y,width,height) 填充一个矩形，(x,y)对应矩形的左上坐标，width,height对应矩形的宽度和高度
			//for循环到上面为止只是建立了矩形框。
			if(j>5){j=0;}
            draw(diceCoordinates[i],j,pointCoordinates[j]);
        }
    }

	//画骰子的点
    function draw(dice,ran,drowArray){//alert(dice+"    "+ran+"     "+drowArray);//[40,10]   0  [20,20]
        ctx.fillStyle = "#fff";
        for(var i=0;i<=ran;i++){
            var array = drowArray[i];
            ctx.beginPath();			//beginPath() 方法在一个画布中开始子路径的一个新的集合。
            if(ran==0){
                //alert(drowArray[0]);
                ctx.arc(drowArray[0]+dice[0],drowArray[1]+dice[1],6,0,Math.PI*2,false);
				/*	
					arc(x,y,r,sAngle,eAngle,counterclockwise);  创建一个圆
					x 	圆的中心的 x 坐标。
					y 	圆的中心的 y 坐标。
					r 	圆的半径。
					sAngle 	起始角，以弧度计。（弧的圆形的三点钟位置是 0 度）。
					eAngle 	结束角，以弧度计。
					counterclockwise 	可选。规定应该逆时针还是顺时针绘图。False = 顺时针，true = 逆时针。
				*/
            }else{
                ctx.arc(array[0]+dice[0],array[1]+dice[1],6,0,Math.PI*2,true);
            }
            ctx.closePath();			//closePath() 方法关闭一条打开的子路径。
            ctx.fill();					//fill() 方法填充路径
        }
    }
	
    //开始摇骰子
    function drawCoordinates(){
        //执行一定次数后放慢速度(使用修改定时执行的时间来达到效果)
        if(count == 30){
            //清除定时执行
            window.clearInterval(tidck);
            //给定时执行赋新的时间
			drawText(ranSum);
			return false;
            tidck = setInterval(drawCoordinates,100);
        }else{
            //每次的时候先把上一次的点数清零
            ranSum = 0;
            //清理画布
            ctx.clearRect(0,0,can.width,100);
            for(var i=0;i<diceCoordinates.length;i++){
                //画笔颜色
                ctx.fillStyle = '#2ea8e5';
                //画正方形
                ctx.fillRect(diceCoordinates[i][0],diceCoordinates[i][1],80,80);
                //获取随机数
                var ran =  Math.floor(Math.random()*6);
                ranSum+=ran+1;
				//画骰子的点
                draw(diceCoordinates[i],ran,pointCoordinates[ran]);
            }            
        }
    count++;
    }
 	
    function drawText(num){					//显示本次骰点数
        //ctx.font = '20px sans-serif';   
        //ctx.fillStyle='#2ea8e5';
        //ctx.fillText("本次摇的点数是："+num,70,280);
        _p.style.display = 'block';
        _p.innerHTML = "本次摇的点数是："+num;
        document.getElementById('btnStart').disabled=false;
    }

    function ctop(){
        win_h = document.documentElement.clientHeight;
        can_h = document.getElementById('canvas').offsetHeight;
        m_top = (win_h - can_h)/2;
        _canvas.style.marginTop = m_top + 'px';
    }