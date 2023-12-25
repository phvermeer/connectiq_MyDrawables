import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Position;

module MyDrawables{

	class GpsSignalIndicator extends WatchUi.Drawable {

		// THESE PROPERTIES COULD BE MODIFIED
		public var darkMode as Boolean;
        public var quality as Quality;
        public var size as Numeric;

		function  initialize(settings as {
			:visible as Boolean,
			:darkMode as Boolean,
            :quality as Quality,
		}) {
			Drawable.initialize(settings);
            darkMode = settings.hasKey(:darkMode) ? settings.get(:darkMode) as Boolean : false;
            quality = settings.hasKey(:quality) ? settings.get(:quality) as Quality : Position.QUALITY_NOT_AVAILABLE;

            var deviceSettings = System.getDeviceSettings();
            var w = deviceSettings.screenWidth;
            var h = deviceSettings.screenHeight;
            size = (w>h ? h : w)/3;
            if(!settings.hasKey(:width)){ width = size; }
            if(!settings.hasKey(:height)){ height = size; }
		}
		
		function draw(dc) {
			// Draw a red edge on top of the screen
			if(isVisible){
                var color = darkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
                // QUALITY_NOT_AVAILABLE  QUALITY_POOR:    QUALITY_USABLE:  QUALITY_GOOD
                // QUALITY_LAST_KNOWN:
                //         ┌─┐                  ┌─┐                ┌─┐             ┌▄┐
                //      ┌─┐│ │               ┌─┐│ │             ┌▄┐│ │          ┌▄┐│█│
                //   ┌─┐│ ││ │            ┌▄┐│ ││ │          ┌▄┐│█││ │       ┌▄┐│█││█│
                //   └─┘└─┘└─┘            └▀┘└─┘└─┘          └▀┘└▀┘└─┘       └▀┘└▀┘└▀┘
                //
                //  └───────┘╶ ╴└───────┘╶ ╴└───────┘    m = margin between bars
                //  ┆   w   ┆ m ┆   w   ┆ m ┆   w   ┆    w = width of bar
                //
                //  w = 2 * m
                //  width = 3*w + 2*m
                //  => m = width * 1/8
                //  => w = width * 2/8

                var m = width / 8f;
                var w = width / 4f;
                // first bar
                var x = locX;
                var h = height/3f;
                var y = locY + (2*h);

                dc.setPenWidth(1);
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                var fill = true;
                var iNoFill = 
                    quality <= Position.QUALITY_LAST_KNOWN ? 1 :
                    quality == Position.QUALITY_POOR ? 2 :
                    quality == Position.QUALITY_USABLE ? 3 : null;
                for(var i=1; i<=3; i++){
                    if(i==iNoFill){
                        fill = false;
                    }
                    if(fill){
                        dc.fillRectangle(x, y, w, i*h);
                    }else{
                        dc.drawRectangle(x, y, w, i*h);
                    }
                    x += m+w;
                    y -= h;
                }
			}
		}
	}
}