kablammo = (window.kablammo || {})
kablammo.Visualization = function Visualization( canvasId, gridWidth, gridHeight, walls, tanks, onTurn ) {
  var canvas = document.getElementById(canvasId);
  var cw = canvas.width = canvas.offsetWidth;
  var ch = canvas.height = canvas.offsetHeight;
  var ctx = canvas.getContext('2d');

  for (var i=0,tank; tank=tanks[i]; i++) {
    for (var j=0,turn; turn = tank.turns[j]; j++) {
      if (turn.fire) console.log(i,turn.fire);
    }
  }

  var GRID_WIDTH = gridWidth;
  var GRID_HEIGHT = gridHeight;
  var SHADOW_OFFSET = .07*ch/GRID_HEIGHT;
  var ROBOT_WIDTH = 100;
  var ROBOT_SCALE = .3;
  var TANK_DIMENSIONS = {
		bw: .4 * ROBOT_WIDTH,
		cp1x: ROBOT_WIDTH,
		cp1y: 1 * ROBOT_WIDTH,
		cp2x: ROBOT_WIDTH,
		cp2y: 0,
		tw: .65 * ROBOT_WIDTH,
		tc: .25 * ROBOT_WIDTH,
		inx: .15 * ROBOT_WIDTH,
		iny: .6 * ROBOT_WIDTH,
    turretY: .2*ROBOT_WIDTH,
    gunStart: .6*ROBOT_WIDTH,
    gunEnd: .7*ROBOT_WIDTH,
    gunWidth: .2*ROBOT_WIDTH
  }

  var COLORS = [
  	{r:240,g:0,b:120},
  	{r:11,g:169,b:234},
  	{r:25,g:222,b:18},
  	{r:255,g:175,b:36}
  ]

	var GRID_POINTS = [
		{left:{x:-TANK_DIMENSIONS.tw, y:-.98*ROBOT_WIDTH},
		 right:{x:-TANK_DIMENSIONS.tc, y:-.98*ROBOT_WIDTH}},
		{left:{x:-.76*ROBOT_WIDTH, y:-3*ROBOT_WIDTH/5},
		 right:{x:-.174*ROBOT_WIDTH, y:-3*ROBOT_WIDTH/5}, bend:.01},
		{left:{x:-.84*ROBOT_WIDTH, y:-1*ROBOT_WIDTH/5},
		 right:{x:-.175*ROBOT_WIDTH, y:-1*ROBOT_WIDTH/5}, bend:.2},
		{left:{x:-.875*ROBOT_WIDTH, y:1*ROBOT_WIDTH/5},
		 right:{x:-.2*ROBOT_WIDTH, y:1*ROBOT_WIDTH/5}, bend:.3},
		{left:{x:-.83*ROBOT_WIDTH, y:3*ROBOT_WIDTH/5},
		 right:{x:-.175*ROBOT_WIDTH, y:3*ROBOT_WIDTH/5}, bend:.4},
		{left:{x:-.5*ROBOT_WIDTH, y:.98*ROBOT_WIDTH},
		 right:{x:-.125*ROBOT_WIDTH, y:.98*ROBOT_WIDTH}, bend:.6}
	]

	function tankBase( tank ) {
		ctx.save();
	  	ctx.rotate(tank.bodyRotation)
			ctx.beginPath();
			ctx.moveTo( -TANK_DIMENSIONS.bw, ROBOT_WIDTH );
			ctx.bezierCurveTo( -TANK_DIMENSIONS.cp1x, TANK_DIMENSIONS.cp1y, 
				-TANK_DIMENSIONS.cp2x, -TANK_DIMENSIONS.cp2y, -TANK_DIMENSIONS.tw, -ROBOT_WIDTH);
			ctx.lineTo( -TANK_DIMENSIONS.tc, -ROBOT_WIDTH);
			ctx.lineTo( -TANK_DIMENSIONS.inx, -TANK_DIMENSIONS.iny );
			ctx.lineTo( TANK_DIMENSIONS.inx, -TANK_DIMENSIONS.iny );
			ctx.lineTo( TANK_DIMENSIONS.tc, -ROBOT_WIDTH);
			ctx.lineTo( TANK_DIMENSIONS.tw, -ROBOT_WIDTH);
			ctx.bezierCurveTo( TANK_DIMENSIONS.cp2x, -TANK_DIMENSIONS.cp2y, TANK_DIMENSIONS.cp1x, TANK_DIMENSIONS.cp1y, 
				TANK_DIMENSIONS.bw, ROBOT_WIDTH);
			ctx.closePath();
			ctx.fill();
		ctx.restore();
	}

	function warp(ctx,tl,tr,bl,br,margin, bend) {
		ctx.beginPath();
		tl = {x:tl.x+margin, y:tl.y+margin};
		tr = {x:tr.x-margin, y:tr.y+margin};
		bl = {x:bl.x+margin, y:bl.y-margin};
		br = {x:br.x-margin, y:br.y-margin};
		ctx.moveTo( tl.x, tl.y );
		ctx.lineTo( tr.x, tr.y );
		var corner = leftCorner(tr,br);
		var middle = between(tr,br);
		var p = between(middle,corner,bend);
		ctx.quadraticCurveTo( p.x, p.y, br.x, br.y );
		ctx.lineTo( bl.x, bl.y );
		corner = leftCorner(tl,bl);
		middle = between(tl,bl);
		p = between(middle,corner,bend)
		ctx.quadraticCurveTo( p.x, p.y, tl.x, tl.y );
		ctx.closePath();
	}

	function leftCorner(p1,p2) { return {x:Math.min(p1.x,p2.x), y:(p1.x<p2.x?p2.y:p1.y)} }

	function between(p1,p2,factor) { 
		factor = factor || .5;
		return {x:p1.x+factor*(p2.x-p1.x), y:p1.y+factor*(p2.y-p1.y)} 
	}

  function decorateStyle( tank ) {
  	var color = COLORS[tank.color];
		ctx.strokeStyle = ctx.fillStyle = 'rgb('+color.r+','+color.g+','+color.b+')';
		ctx.shadowOffsetX = 0;
		ctx.shadowOffsetY = 0;
		ctx.shadowColor = 'rgb('+color.r+','+color.g+','+color.b+')';
		ctx.shadowBlur = .06*ROBOT_WIDTH;
  }

	function decorateTankBody( tank ) {
		var MARGIN = .05 * ROBOT_WIDTH;

		ctx.save();
		ctx.rotate(tank.bodyRotation);
		decorateStyle( tank );

		for (var i=1,row; row = GRID_POINTS[i]; i++) {
			var prev = GRID_POINTS[i-1];
			var prevCenter = between(prev.left,prev.right);
			var rowCenter = between(row.left,row.right);

	  	(( tank.id & (1<<i) ) ? decorateStyle : offStyle)( tank );
			warp(ctx,prev.left,prevCenter,row.left,rowCenter,MARGIN,row.bend);
			ctx.fill();
			ctx.save();
				ctx.scale(-1,1);
  			warp(ctx,prev.left,prevCenter,row.left,rowCenter,MARGIN,row.bend);
				ctx.fill();
			ctx.restore();

	  	(( tank.id & (1<<(i+5)) ) ? decorateStyle : offStyle)( tank );
			warp(ctx,prevCenter,prev.right,rowCenter,row.right,MARGIN,row.bend);
			ctx.fill();
			ctx.save();
				ctx.scale(-1,1);
				warp(ctx,prevCenter,prev.right,rowCenter,row.right,MARGIN,row.bend);
				ctx.fill();
			ctx.restore();
		}
  	ctx.restore();
  }

  function turretPath() {
		ctx.beginPath();
		ctx.arc(0,0, ROBOT_WIDTH/2, 0, 2*Math.PI, true);
		ctx.fill();
		ctx.fillRect(-TANK_DIMENSIONS.gunWidth/2, -TANK_DIMENSIONS.gunStart,
                  TANK_DIMENSIONS.gunWidth,-TANK_DIMENSIONS.gunEnd);
  }

  function offStyle() {
  	ctx.fillStyle = ctx.strokeStyle = 'rgba(200,200,200,.2)';
  	ctx.shadowBlur = 0;
  }

  function decorateTurret( tank ) {
  	(( tank.id & (1<<11) ) ? decorateStyle : offStyle)( tank );
		ctx.lineWidth = 5;
		ctx.beginPath();
		ctx.arc(0, 0, 6.5*ROBOT_WIDTH/16, 0, 2*Math.PI, true);
		ctx.stroke();

  	(( tank.id & (1<<11) ) ? decorateStyle : offStyle)( tank );
		ctx.beginPath();
		ctx.arc(0, 0, 4.25*ROBOT_WIDTH/16, 0, 2*Math.PI, true);
		ctx.stroke();

  	(( tank.id & (1<<13) ) ? decorateStyle : offStyle)( tank );
		ctx.beginPath();
		ctx.arc(0, 0, 2*ROBOT_WIDTH/16, 0, 2*Math.PI, true);
		ctx.fill();

  	(( tank.id & (1<<14) ) ? decorateStyle : offStyle)( tank );
		ctx.fillRect(-.6*TANK_DIMENSIONS.gunWidth/2,-.75*ROBOT_WIDTH,.6*TANK_DIMENSIONS.gunWidth,-.2*ROBOT_WIDTH);

  	(( tank.id & (1<<15) ) ? decorateStyle : offStyle)( tank );
		ctx.fillRect(-.6*TANK_DIMENSIONS.gunWidth/2,-1.05*ROBOT_WIDTH,.6*TANK_DIMENSIONS.gunWidth,-.2*ROBOT_WIDTH);
  }

  // finds end of gun in canvas coordinates
  function gunEnd( tank ) {
    return {
      x: (tank.x+.5)*cw/GRID_WIDTH + ROBOT_SCALE*
          (-Math.sin(tank.bodyRotation)*TANK_DIMENSIONS.turretY + 
            (TANK_DIMENSIONS.gunStart+TANK_DIMENSIONS.gunEnd)*Math.sin(tank.turretAngle)),
      y: (tank.y+.5)*ch/GRID_HEIGHT +  ROBOT_SCALE*
          (Math.cos(tank.bodyRotation)*TANK_DIMENSIONS.turretY - 
            (TANK_DIMENSIONS.gunStart+TANK_DIMENSIONS.gunEnd)*Math.cos(tank.turretAngle))
    }
  }

  function updateTank( tank, time ) {
    var lastTurn = tank.turns[Math.max((time-1)|0,0)];
    var turn = tank.turns[time|0];
    var subStep = time % 1;
    if ( (lastTurn.direction - turn.direction) % 2 ) {
      if ( subStep < .5 ) {
        tank.x = lastTurn.x;
        tank.y = lastTurn.y;
        var startRotation = -lastTurn.direction * Math.PI / 2;
        var endRotation = -turn.direction * Math.PI / 2;
        if (endRotation-startRotation > Math.PI)
          endRotation -= 2*Math.PI;
        if (endRotation-startRotation < -Math.PI)
          endRotation += 2*Math.PI;
        tank.bodyRotation = startRotation + 2*subStep*(endRotation-startRotation);
      } else {
        tank.x = lastTurn.x + 2*(subStep-.5)*(turn.x-lastTurn.x);
        tank.y = lastTurn.y + 2*(subStep-.5)*(turn.y-lastTurn.y);
        tank.bodyRotation = -turn.direction * Math.PI / 2;
      }
    } else {
      tank.x = lastTurn.x + subStep*(turn.x-lastTurn.x);
      tank.y = lastTurn.y + subStep*(turn.y-lastTurn.y);
    }
    tank.turretAngle = lastTurn.turretAngle + subStep*(turn.turretAngle-lastTurn.turretAngle);
    tank.target = turn.fire && subStep >= .05 ? turn.fire : false;
  }

  function renderTank( tank ) {
  	ctx.save();
  		ctx.translate((tank.x+.5)*cw/GRID_WIDTH, (tank.y+.5)*ch/GRID_HEIGHT);
  		ctx.scale(ROBOT_SCALE, ROBOT_SCALE);

	  	var shadowOffset = .15*ROBOT_WIDTH;

			// body shadow			
			ctx.save();
				ctx.translate(shadowOffset,-shadowOffset);
	  		ctx.fillStyle = 'rgba(0,0,0,.75)';
			  tankBase(tank);
	  	ctx.restore();

	  	// body
		  ctx.fillStyle = 'rgba(255,255,255,.5)';
		  tankBase(tank);

  		ctx.save();
  			// turret shadow
				ctx.save();
		  		ctx.rotate(tank.bodyRotation)
					ctx.translate(0,TANK_DIMENSIONS.turretY);
		  		ctx.rotate(-tank.bodyRotation)
					ctx.translate(shadowOffset,-shadowOffset);
					ctx.rotate(tank.turretAngle);
		  		ctx.fillStyle = 'rgba(0,0,0,.6)';
				  turretPath();
		  	ctx.restore();

		  	// body decoration
	  		decorateTankBody( tank );

	  		// turret
				ctx.save();
		  		ctx.rotate(tank.bodyRotation)
					ctx.translate(0,TANK_DIMENSIONS.turretY);
		  		ctx.rotate(-tank.bodyRotation)
					ctx.rotate(tank.turretAngle);
				  ctx.fillStyle = 'rgba(235,235,235,.7)';
				  turretPath();

				  decorateTurret( tank );

				ctx.restore();

	  	ctx.restore();

  	ctx.restore();
  }


  function renderTankFire( tank, target ) {
    ctx.fillStyle = '#ff0';
    ctx.fillRect(target[0]*cw/GRID_WIDTH, target[1]*ch/GRID_HEIGHT, cw/GRID_WIDTH, ch/GRID_HEIGHT);

    ctx.strokeStyle = '#ff0';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo((tank.x+.5)*cw/GRID_WIDTH, (tank.y+.5)*ch/GRID_HEIGHT)
    ctx.lineTo((target[0]+.5)*cw/GRID_WIDTH, (target[1]+.5)*ch/GRID_HEIGHT)
    ctx.stroke();

    var gunPos = gunEnd(tank);
    var dx = (target[0]+.5)*cw/GRID_WIDTH - gunPos.x;
    var dy = (target[1]+.5)*ch/GRID_HEIGHT - gunPos.y;
    var distance = Math.sqrt(dx*dx + dy*dy);
    ctx.save();
      ctx.translate((tank.x+.5)*cw/GRID_WIDTH, (tank.y+.5)*ch/GRID_HEIGHT);
      ctx.scale(ROBOT_SCALE, ROBOT_SCALE);

      ctx.save();
        ctx.rotate(tank.bodyRotation)
        ctx.translate(0,TANK_DIMENSIONS.turretY);
        ctx.rotate(-tank.bodyRotation)
        ctx.rotate(tank.turretAngle);

        decorateStyle(tank);
        ctx.shadowColor = '#fff';
        ctx.lineWidth = 16;
        ctx.beginPath();
        ctx.moveTo(0, -1.4*ROBOT_WIDTH);
        ctx.lineTo(0, -distance/ROBOT_SCALE )
        ctx.stroke();
      ctx.restore();

    ctx.restore();
  }

  var startTime = 0;
  var gameTime = 0;
  var currentTurn = -1;
  function render( time ) {
  	if ( startTime == 0 ) startTime = time;
  	gameTime = (time - startTime) / 1000;
		for (var i=0,tank; tank = tanks[i]; i++)
      if (gameTime >= tank.turns.length)
        return false;

  	ctx.fillStyle = '#383838';
  	ctx.fillRect(0,0,cw,ch);

  	for (var i=0; i<GRID_WIDTH; i++) {
  		for (var j=GRID_HEIGHT-1; j>=0; j--) {
  			if (walls[i] && walls[i][j]) {
  				ctx.fillStyle = 'rgba(0,0,0,.75)';
  				ctx.fillRect(cw*i/GRID_WIDTH + SHADOW_OFFSET, ch*j/GRID_HEIGHT - SHADOW_OFFSET, 
  					cw/GRID_WIDTH, ch/GRID_HEIGHT)
  				ctx.fillStyle = 'rgba(235,235,235,.7)';
  				ctx.fillRect(cw*i/GRID_WIDTH, ch*j/GRID_HEIGHT, 
  					cw/GRID_WIDTH, ch/GRID_HEIGHT)
  			}
  		}
  	}

  	ctx.strokeStyle = '#212121';
  	ctx.lineWidth = 1.5;
  	for (var i=1; i<GRID_WIDTH; i++) {
  		ctx.moveTo(i*cw/GRID_WIDTH, 0);
  		ctx.lineTo(i*cw/GRID_WIDTH, ch);
    }

    for (var i=1; i<GRID_HEIGHT; i++) {
  		ctx.moveTo(0, i*ch/GRID_HEIGHT);
  		ctx.lineTo(cw, i*ch/GRID_HEIGHT);
  	}
  	ctx.stroke();

  	for (var i=0,tank; tank = tanks[i]; i++)
	  	updateTank(tank, gameTime);

    for (var i=0,tank; tank = tanks[i]; i++)
      if (tank.target)
        renderTankFire(tank, tank.target);

    for (var i=0,tank; tank = tanks[i]; i++)
      renderTank(tank);

    var turnIndex = gameTime|0;
    var subStep = gameTime % 1
    if (turnIndex > currentTurn && subStep >= 0.5) {
      currentTurn = turnIndex;
      if (onTurn) {
        onTurn(currentTurn);
      }
    }

    return true;
  }

  function draw() {
    requestAnimationFrame(render);
  }

  function turn() {
  }

  function play() {
    requestAnimationFrame(function(time) {
      var playing = render(time);
      if (playing) play();
    });
  }

  function stop() {
  }

  return { draw:draw, turn:turn, play:play, stop:stop };
}
