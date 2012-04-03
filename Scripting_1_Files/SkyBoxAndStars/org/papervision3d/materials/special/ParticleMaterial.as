package org.papervision3d.materials.special
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.core.render.draw.IParticleDrawer;
	
	
	//Imports for Additional Drawing primitives
	//import mx.core.UIComponent;
	
		


	/**
	 * @Author Ralph Hauwert
	 * 
	 * updated by Seb Lee-Delisle 
	 *  - added size implementation
	 *  - added rectangle of particle for smart culling and drawing
	 * 
	 */
	public class ParticleMaterial extends MaterialObject3D implements IParticleDrawer
	{
		
		public static var SHAPE_SQUARE:int = 0; 
		public static var SHAPE_CIRCLE:int = 1;
		
		//Lively
		
		public static var SHAPE_STAR:int =  2;
		public static var SHAPE_GEAR:int =  3;
		public static var SHAPE_WEDGE:int = 4;
		public static var SHAPE_POLY:int =  5;
		public static var SHAPE_BURST:int = 6;
		
		
		
				public var shape : int; 
		public function ParticleMaterial(color:Number, alpha:Number, shape:int = 0 )
		{
			super();
			this.shape = shape; 
			this.fillAlpha = alpha;
			this.fillColor = color;
			
			
		}
		
		
		public function drawParticle(particle:Particle, graphics:Graphics, renderSessionData:RenderSessionData):void
		{
			graphics.beginFill(fillColor, fillAlpha);
			
			var renderrect:Rectangle = particle.renderRect; 
			
			trace(renderrect.x+",y= "+renderrect.y+" ,width= ", renderrect.width+" ,height= "+renderrect.height );
			
			
	switch(shape)
{
    case SHAPE_SQUARE:
        graphics.drawRect(renderrect.x, renderrect.y, renderrect.width, renderrect.height);
        break;
        
    case SHAPE_CIRCLE:
        graphics.drawCircle(renderrect.x+renderrect.width/2, renderrect.y+renderrect.width/2, renderrect.width/2);
        break;
        
    case SHAPE_STAR:
            var points:int=6;	
            var innerRadius:Number=renderrect.width/10;
			var outerRadius:Number=renderrect.width*2;
            
			var count:int = Math.abs(points);
			if (count>=2) 
			{
				
				
				// calculate distance between points
				var step:Number = (Math.PI*2)/points;
				var halfStep:Number = step/2;
				
				// calculate starting angle in radians
				var start:Number = (20/180)*Math.PI;
				graphics.moveTo(renderrect.x+(Math.cos(start)*outerRadius), renderrect.y-(Math.sin(start)*outerRadius));
				
				// draw lines
				for (var i:int=1; i<=count; i++) 
				{
					graphics.lineTo(renderrect.x+Math.cos(start+(step*i)-halfStep)*innerRadius, 
					renderrect.y-Math.sin(start+(step*i)-halfStep)*innerRadius);

					graphics.lineTo(renderrect.x+Math.cos(start+(step*i))*outerRadius, 
					renderrect.y-Math.sin(start+(step*i))*outerRadius);
				}
			}
			
        break;
    case SHAPE_GEAR:
    
        var gearPoints:int=5;
        
        var ginnerRadius:Number=renderrect.width/2;
		var gouterRadius:Number=renderrect.width;
		var holeSides:int=4;
		var holeRadius:Number=renderrect.width/4;
    
        if (gearPoints>=2) 
			{
				
				// calculate length of sides
				var gearStep:Number = (Math.PI*2)/gearPoints;
				var gearQtrStep:Number = gearStep/4;
				
				// calculate starting angle in radians
				var gearStart:Number = (20/180)*Math.PI;
				graphics.moveTo(renderrect.x+(Math.cos(gearStart)*gouterRadius), renderrect.y-(Math.sin(gearStart)*gouterRadius));
				
				// draw lines
				for (var j:int=1; j<=gearPoints; j++) 
				{
					graphics.lineTo(renderrect.x+Math.cos(gearStart+(gearStep*j)-(gearQtrStep*3))*ginnerRadius, 
					renderrect.y-Math.sin(gearStart+(gearStep*j)-(gearQtrStep*3))*ginnerRadius);
					
					graphics.lineTo(renderrect.x+Math.cos(gearStart+(gearStep*j)-(gearQtrStep*2))*ginnerRadius, 
					renderrect.y-Math.sin(gearStart+(gearStep*j)-(gearQtrStep*2))*ginnerRadius);
					
					graphics.lineTo(renderrect.x+Math.cos(gearStart+(gearStep*j)-gearQtrStep)*gouterRadius, 
					renderrect.y-Math.sin(gearStart+(gearStep*j)-gearQtrStep)*gouterRadius);
					
					graphics.lineTo(renderrect.x+Math.cos(gearStart+(gearStep*j))*gouterRadius, 
					renderrect.y-Math.sin(gearStart+(gearStep*j))*gouterRadius);
				}
								
				if (holeSides>=2) 
				{
					if(holeRadius == 0) 
					{
						holeRadius = ginnerRadius/3;
					}
					
					gearStep = (Math.PI*2)/holeSides;
					graphics.moveTo(renderrect.x+(Math.cos(gearStart)*holeRadius), renderrect.y-(Math.sin(gearStart)*holeRadius));
					
					for (var k:int=1; k<=holeSides; k++) 
					{
						graphics.lineTo(renderrect.x+Math.cos(gearStart+(gearStep*k))*holeRadius, 
						renderrect.y-Math.sin(gearStart+(gearStep*k))*holeRadius);
					}
				}
				
			}
        break;
        
    case SHAPE_WEDGE:
        // move into position
        
        
            var arc:Number=40;
            var radius:Number= renderrect.width*2;
            var yRadius:Number= renderrect.width;    
            var wedgeStartAngle:Number=20;  
        
			graphics.moveTo(renderrect.x, renderrect.y);
						
			// limit sweep to reasonable numbers
			if (Math.abs(arc)>360) 
			{
				arc = 360;
			}
			
			// Draw in a maximum of 45 degree segments. First we calculate how 
			// many segments are needed for our arc.
			var segs:Number = Math.ceil(Math.abs(arc)/45);
			
			// Now calculate the sweep of each segment.
			var segAngle:Number = arc/segs;
			
			// The math requires radians rather than degrees. To convert from degrees
			// use the formula (degrees/180)*Math.PI to get radians.
			var theta:Number =-(segAngle/180)*Math.PI;
								
			// convert angle startAngle to radians
			var angle:Number =-(wedgeStartAngle/180)*Math.PI;
			
			// draw the curve in segments no larger than 45 degrees.
			if (segs>0) 
			{
				
				// draw a line from the center to the start of the curve
				graphics.lineTo(renderrect.x+Math.cos(wedgeStartAngle/180*Math.PI)*radius, 
				renderrect.y+Math.sin(-wedgeStartAngle/180*Math.PI)*yRadius);
				
				//draw curve segments
				for (var m:int = 0; m<segs; m++) 
				{
					angle += theta;
					
					var angleMid:Number = angle-(theta/2);
					graphics.curveTo(renderrect.x+Math.cos(angleMid)*(radius/Math.cos(theta/2)), 
					renderrect.y+Math.sin(angleMid)*(yRadius/Math.cos(theta/2)), 
					renderrect.x+Math.cos(angle)*radius, renderrect.y+Math.sin(angle)*yRadius);
					
				}
				
				//close the wedge by drawing a line to the center
				graphics.lineTo(renderrect.x, renderrect.y);
				
			}


        break;
        
    case SHAPE_POLY:
    
        var polyPoints:int=7;
        var myCount:int = Math.abs(polyPoints);
        var polyAngle:Number=20;
        var polyRadius:Number=renderrect.width;
        
			
			if (myCount>=2) 
			{
				
				// calculate span of sides
				var polyStep:Number = (Math.PI*2)/polyPoints;
				
				// calculate starting angle in radians
				var polyStart:Number = (polyAngle/180)*Math.PI;
				graphics.moveTo(renderrect.x+(Math.cos(polyStart)*polyRadius), renderrect.y-(Math.sin(polyStart)*polyRadius));
				
				// draw the polygon
				for (var n:int=1; n<=myCount; n++) 
				{
					graphics.lineTo(renderrect.x+Math.cos(polyStart+(polyStep*n))*polyRadius, 
					renderrect.y-Math.sin(polyStart+(polyStep*n))*polyRadius);
				}
				
			}
        break;
    case SHAPE_BURST:
    
        var binnerRadius:Number=renderrect.width/2;
		var bouterRadius:Number=renderrect.width;
		var bAngle:int=20;
		var bPoints:int=7
		
   
        if (bPoints >=2) 
			{
				
				// calculate length of sides
				var bStep:Number = (Math.PI*2)/bPoints;
				var bHalfStep:Number = bStep/2;
				var bQtrStep:Number = bStep/4;
				
				// calculate starting angle in radians
				var bStart:Number = (bAngle/180)*Math.PI;
				
				graphics.moveTo(renderrect.x+(Math.cos(bStart)*bouterRadius), renderrect.y-(Math.sin(bStart)*bouterRadius));
				
				// draw curves
				for (var p:int=1; p<=bPoints; p++) 
				{
					
					graphics.curveTo(renderrect.x+Math.cos(bStart+(bStep*p)-(bQtrStep*3))*(binnerRadius/Math.cos(bQtrStep)), 
					renderrect.y-Math.sin(bStart+(bStep*p)-(bQtrStep*3))*(binnerRadius/Math.cos(bQtrStep)), 
					renderrect.x+Math.cos(bStart+(bStep*p)-bHalfStep)*binnerRadius, 
					renderrect.y-Math.sin(bStart+(bStep*p)-bHalfStep)*binnerRadius);
					
					
					graphics.curveTo(renderrect.x+Math.cos(bStart+(bStep*p)-bQtrStep)*(binnerRadius/Math.cos(bQtrStep)), 
					renderrect.y-Math.sin(bStart+(bStep*p)-bQtrStep)*(binnerRadius/Math.cos(bQtrStep)), 
					renderrect.x+Math.cos(bStart+(bStep*p))*bouterRadius, 
					renderrect.y-Math.sin(bStart+(bStep*p))*bouterRadius);
					
				}
				
			}
        break;
    default:
        trace("warning - Particle material has no valid shape.");
        break;
}

			
			
			graphics.endFill();
			renderSessionData.renderStatistics.particles++;
		}
		

		
		public function updateRenderRect(particle : Particle) :void
		{
			var renderrect:Rectangle = particle.renderRect; 

			if(particle.size == 0){

				renderrect.width = 1; 
				renderrect.height = 1; 
			}else{
				renderrect.width = particle.renderScale*particle.size;
				renderrect.height = particle.renderScale*particle.size;
			}
			renderrect.x = particle.vertex3D.vertex3DInstance.x - (renderrect.width/2); 
			renderrect.y = particle.vertex3D.vertex3DInstance.y - (renderrect.width/2);
			
		}
	}
}