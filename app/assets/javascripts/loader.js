//edited from original found here - http://codepen.io/hoqqanen/pen/zvqGEG

var checkmarkIdPrefix = "loadingCheckSVG-";
var checkmarkCircleIdPrefix = "loadingCheckCircleSVG-";
var verticalSpacing = 50;

function shuffleArray(array) {
  for (var i = array.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
  return array;
}

function createSVG(tag, properties, opt_children) {
  var newElement = document.createElementNS("http://www.w3.org/2000/svg", tag);
  for(prop in properties) {
    newElement.setAttribute(prop, properties[prop]);
  }
  if (opt_children) {
    opt_children.forEach(function(child) {
      newElement.appendChild(child);
    })
  }
  return newElement;
}

function createPhraseSvg(phrase, yOffset) {
  var text = createSVG("text", {
    fill: "black",
    x: 50,
    y: yOffset,
    "font-size": 18,
    "font-family": "Helvetica, Arial sans-serif"
  });
  text.appendChild(document.createTextNode(phrase + "..."));
  return text;
}
function createCheckSvg(yOffset, index) {
  var check = createSVG("polygon", {
    points: "21.661,7.643 13.396,19.328 9.429,15.361 7.075,17.714 13.745,24.384 24.345,9.708 ",
    fill: "rgba(0,0,0,1)",
    id: checkmarkIdPrefix + index
  });
  var circle_outline = createSVG("path", {
    d: "M16,0C7.163,0,0,7.163,0,16s7.163,16,16,16s16-7.163,16-16S24.837,0,16,0z M16,30C8.28,30,2,23.72,2,16C2,8.28,8.28,2,16,2 c7.72,0,14,6.28,14,14C30,23.72,23.72,30,16,30z",
    fill: "black"
  })
  var circle = createSVG("circle", {
    id: checkmarkCircleIdPrefix + index,
    fill: "rgba(255,255,255,0)",
    cx: 16,
    cy: 16,
    r: 15
  })
  var group = createSVG("g", {
    transform: "translate(10 " + (yOffset - 20) + ") scale(.9)"
  }, [circle, check, circle_outline]);
  return group;
}

function addPhrasesToDocument(phrases) {
  phrases.forEach(function(phrase, index) {
    var yOffset = 30 + verticalSpacing * index;
    document.getElementById("phrases").appendChild(createPhraseSvg(phrase, yOffset));
    document.getElementById("phrases").appendChild(createCheckSvg(yOffset, index));
  });
}

function easeInOut(t) {
  var period = 200;
  return (Math.sin(t / period + 100) + 1) /2;
}

document.addEventListener("DOMContentLoaded", function(event) {
  var phrases = shuffleArray(["Stealing Your IP Address", "Pulling your todo list items", "Selling Your Habits", "Laughing To The Bank", "Wandering Aimlessly", "How Long Does This Take?", "Rolling In A Meadow", "Who Is Behind You?", "Nice Haircut!", "Avg. Airspeed Velocity Of A Swallow?", "Hey Mom!", "Gettin' Yo Train Delays", "Hopefully You Aren't In Boston", "Doin' Stuff", "Servin' Dem Pages", "Bob Dole", "Frederick Douglass","Póg Mo Thóin", "Playing Super Mario Kart", "Eating Brunch"]);
  addPhrasesToDocument(phrases);
  var start_time = new Date().getTime();
  var upward_moving_group = document.getElementById("phrases");
  upward_moving_group.currentY = 0;
  var checks = phrases.map(function(_, i) { 
    return {check: document.getElementById(checkmarkIdPrefix + i), circle: document.getElementById(checkmarkCircleIdPrefix + i)};
  });
  function animateLoading() {
    var now = new Date().getTime();
    upward_moving_group.setAttribute("transform", "translate(0 " + upward_moving_group.currentY + ")");
    upward_moving_group.currentY -= 1.35 * easeInOut(now);
    checks.forEach(function(check, i) {
      var color_change_boundary = - i * verticalSpacing + verticalSpacing + 15;
      if (upward_moving_group.currentY < color_change_boundary) {
        var alpha = Math.max(Math.min(1 - (upward_moving_group.currentY - color_change_boundary + 15)/30, 1), 0);
        check.circle.setAttribute("fill", "rgba(255, 255, 255, " + alpha + ")");
        var check_color = [Math.round(255 * (1-alpha) + 120 * alpha), Math.round(255 * (1-alpha) + 154 * alpha)];
        check.check.setAttribute("fill", "rgba(255, " + check_color[0] + "," + check_color[1] + ", 1)");
      }
    })
    if (now - start_time < 30000 && upward_moving_group.currentY > -710) {
      requestAnimationFrame(animateLoading);
    }
  }
  //animateLoading();
});