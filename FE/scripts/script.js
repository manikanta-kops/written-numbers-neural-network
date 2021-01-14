(function () {
  const canvasSize = {
    width: 100,
    height: 100,
  };

  const Training_Data = [];
  const Y = [];
  // const datasetCanvasSize = {
  //   width: 20,
  //   height: 20,
  // };

  let canvas,
    ctx,
    flag = false,
    prevX = 0,
    currX = 0,
    prevY = 0,
    currY = 0,
    dot_flag = false;
  var color = "black",
    y = 2;
  function init() {
    canvas = document.getElementById("mycanvas");
    ctx = canvas.getContext("2d");
    canvas.width = canvasSize.width;
    canvas.height = canvasSize.height;

    canvas.addEventListener(
      "mousemove",
      function (e) {
        findxy("move", e);
      },
      false
    );
    canvas.addEventListener(
      "touchmove",
      function (e) {
        findxy("move", e, "TOUCH");
      },
      false
    );

    canvas.addEventListener(
      "mousedown",
      function (e) {
        findxy("down", e);
      },
      false
    );
    canvas.addEventListener(
      "touchstart",
      function (e) {
        findxy("down", e, "TOUCH");
      },
      false
    );

    canvas.addEventListener(
      "mouseup",
      function (e) {
        findxy("up", e);
      },
      false
    );

    canvas.addEventListener(
      "touchend",
      function (e) {
        findxy("out", e, "TOUCH");
      },
      false
    );
    canvas.addEventListener(
      "mouseout",
      function (e) {
        findxy("out", e);
      },
      false
    );
    // canvas.addEventListener(
    //   "click",
    //   function (e) {
    //     let data = canvas
    //       .getContext("2d")
    //       .getImageData(event.offsetX, event.offsetY, 1, 1).data;
    //     console.log(data);
    //   },
    //   false
    // );
    _toggleLoader("HIDE");
  }

  function draw() {
    ctx.beginPath();
    ctx.moveTo(prevX, prevY);
    ctx.lineTo(currX, currY);
    ctx.strokeStyle = color;
    ctx.lineWidth = y;
    ctx.stroke();
    ctx.closePath();
  }
  function erase() {
    ctx.clearRect(0, 0, canvasSize.width, canvasSize.height);
  }
  function save() {
    document.getElementById("canvasimg").style.border = "2px solid";
    var dataURL = canvas.toDataURL();
    document.getElementById("canvasimg").src = dataURL;
    document.getElementById("canvasimg").style.display = "inline";
  }
  function findxy(res, e, from) {
    if (from === "TOUCH") {
      let touches = e.touches[0];
      if (touches) {
        e.clientX = touches.clientX;
        e.clientY = touches.clientY;
      } else {
        return;
      }
    }

    if (res == "down") {
      prevX = currX;
      prevY = currY;
      currX = e.clientX - canvas.offsetLeft;
      currY = e.clientY - canvas.offsetTop;
      flag = true;
      dot_flag = true;
      if (dot_flag) {
        ctx.beginPath();
        ctx.fillStyle = color;
        ctx.fillRect(currX, currY, 2, 2);
        ctx.closePath();
        dot_flag = false;
      }
    }
    if (res == "up" || res == "out") {
      flag = false;
    }
    if (res == "move") {
      if (flag) {
        prevX = currX;
        prevY = currY;
        currX = e.clientX - canvas.offsetLeft;
        currY = e.clientY - canvas.offsetTop;
        draw();
      }
    }
  }

  function train() {
    _toggleLoader("SHOW");
    let data = canvas
      .getContext("2d")
      .getImageData(0, 0, canvas.width, canvas.height).data;

    let finalSet = [];
    let i = 0;
    while (i < data.length) {
      i = i + 4; // R G B A
      let currentAlpha = data[i - 1]; //A
      finalSet.push(currentAlpha / 255);
    }
    let inputValue = document.getElementById("my_input").value;
    console.log(inputValue);
    _callNodeApiToSaveTheData({
      inputValue: inputValue,
      params: finalSet,
    });
    erase();
  }

  function _callNodeApiToSaveTheData({ inputValue, params }) {
    var myHeaders = new Headers();
    myHeaders.append("Content-Type", "application/x-www-form-urlencoded");
    // myHeaders.append("Access-Control-Allow-Origin", "*");

    var urlencoded = new URLSearchParams();
    urlencoded.append("inputValue", inputValue);
    urlencoded.append("params", JSON.stringify(params));

    var requestOptions = {
      method: "POST",
      headers: myHeaders,
      mode: "no-cors",
      body: urlencoded,
      redirect: "follow",
    };

    fetch("http://192.168.0.105:4040/ml/write2file", requestOptions)
      .then((response) => response.text())
      .then((result) => {
        _toggleLoader("HIDE");
      })
      .catch((error) => {
        alert("ERRORRRRRRRRRRRRRR!");
        _toggleLoader("HIDE");
      });
  }

  function _toggleLoader(state) {
    let loader = document.getElementById("loader");
    if (state === "SHOW") {
      loader.style.display = "block";
    } else {
      loader.style.display = "none";
    }
  }

  function downLoadTheData() {
    let rows = Training_Data;
    let csvContent =
      "data:text/csv;charset=utf-8," + rows.map((e) => e.join(",")).join("\n");
    var encodedUri = encodeURI(csvContent);
    window.open(encodedUri);

    csvContent = "data:text/csv;charset=utf-8," + Y.join("\n");
    encodedUri = encodeURI(csvContent);
    window.open(encodedUri);
  }

  window.init = init;
  window.erase = erase;
  window.train = train;
  window.downLoadTheData = downLoadTheData;
})();
