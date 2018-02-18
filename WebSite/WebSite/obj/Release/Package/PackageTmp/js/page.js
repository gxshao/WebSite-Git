var LoginTips = "#Txt_tips";
var SignInfomation = "#Txt_SignInfo";
var SmallLogin = "smalllgoin";
var DivLogin = "#login_layer";
var BtnLogin = "#Btn_Login";
var MainLayer = "#Main_Layer";
function layopacity(id) {
    var view = id;
    view.hidden = false;
    var timer;
    var i = 0;
    timer = setInterval(function fs() {
        i++;
        view.style.opacity = i / 100;
        view.style.filter = 'alpha(opacity=' + i + ')';
        if (i == 100) {
            clearInterval(timer);
        }
    }, 5);
}
function hideopacity(id) {
    var view = id;
    var timer;
    var i = 100;
    timer = setInterval(function fs() {
        i--;
        view.style.opacity = i / 100;
        view.style.filter = 'alpha(opacity=' + i + ')';
        if (i == 0) {
            view.hidden = true;
            clearInterval(timer);
        }
    }, 5);
}
function moveelem(id, way, num, start) {
    var per = id;
    var timer;
    var i = start;
    switch (way) {
        case 1:
            timer = setInterval(function move() {
                i -= 1.5;
                per.style.marginTop = i + "px"
                if (i <= num) {
                    clearInterval(timer);
                }
            }, 8);
            break;
        case 2:
            timer = setInterval(function move() {
                i += 1.5;
                per.style.marginTop = i + "px"
                if (i >= num) {
                    clearInterval(timer);
                }
            }, 8);
            break;
        case 3:
            timer = setInterval(function move() {
                i -= 1.5;
                per.style.marginLeft = i + "px"
                if (i >= num) {
                    clearInterval(timer);
                }
            }, 8);
            break;
        case 4:
            timer = setInterval(function move() {
                i += 1.5;
                per.style.marginLeft = i + "px"
                if (i >= num) {
                    clearInterval(timer);
                }
            }, 8);
            break;
    }

}
function Login() {
        var usr = $("#txt_usr").val();
        var pwd = $("#txt_pwd").val();
        var smalllgoin = document.getElementById(SmallLogin);
        var txt = document.getElementById(LoginTips.substr(1, LoginTips.length));
        if (usr == "" || pwd == "") {
            $(LoginTips).text("用户名或密码不能为空！");
            //警告层  
            return;
        } else {
            hideopacity(smalllgoin);
            var move = function () {
                $(LoginTips).text("Loading..");
                moveelem(txt, 2, 120, 50);
            }
            setTimeout(move, 400);
        }
        var text = "key=ÂÁÉÇÀ&usr=" + usr + "&pwd=" + pwd;
        setTimeout(function () { postdata(1, text); }, 1000);
}
function postdata(ord, text) {
    $.ajax({
        type: "POST",
        url: "../ajax/HandMsg.ashx", data: text, success: function (data) {
            //
            switch (ord) {
                case 1:
                    eval(data);
                    switch (msg) {
                        case 0:
                            $(LoginTips).text("Welcome to mrsgx.cn");
                            $(BtnLogin).text(usr);
                            setTimeout(function () { $(DivLogin).hide(); }, 500);
                            setTimeout(function () { $(MainLayer).show(); }, 600);
                            break;
                        case -1:
                            Loginfailed("密码错误!");
                            break;
                        case -2:
                            Loginfailed("用户不存在!");
                            break;
                        case -3:
                            Loginfailed("服务器错误!");
                            break;
                        default:
                            Loginfailed("未知错误!");
                            break;
                    }
                    break;
                case 2:
                    $(SignInfomation).text(data);
                    break;
                case 3:
                    break;
                case 4:
                    break;
                case 5:
                    eval(data);
                    $(LoginTips).text(msg);
                    $(DivLogin).show();
                    if (msg == '注销成功！')
                    {
                        $(MainLayer).hide();
                        var view = document.getElementById(SmallLogin);
                        var txt_tips = document.getElementById(LoginTips.substr(1, LoginTips.length));
                        moveelem(txt_tips,1,120,50);
                        setTimeout(function () { layopacity(view) }, 500);
                    }
                    break;
                default:

            }

        }
    });
}
function Loginfailed(text) {
    var smalllogin = document.getElementById(SmallLogin);
    $(LoginTips).text(text);
    var txt_tips = document.getElementById(LoginTips.substr(1, LoginTips.length));
    moveelem(txt_tips, 1, 50, 120);
    setTimeout(function () { layopacity(smalllogin); }, 400);
}