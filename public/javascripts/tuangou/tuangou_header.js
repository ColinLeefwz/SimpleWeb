// 显示div:dy-tanchu1
function subScription1(self) {

    var id = self.getAttribute("id");
    if(id == 'dy') {
        $('span1').innerHTML = $('dy').innerHTML;
        $('status1').setAttribute("value", "1");
    } else {
        $('span1').innerHTML = $('qx').innerHTML
        $('status1').setAttribute("value", "0");
    }
    $('dy-tanchu1').style.display = "";
    $('phone1').focus();
    $('recognize_captcha1').click();
}

// 隐藏div:dy-tanchu1清除数据
function csubScription1() {
    $('captcha').value = "";
    $('phone1').value="";
    $('dy-tanchu1').style.display = "none";
}

// 显示div:dy-tanchu2
function subScription2(phone,status) {
    if (status == "1") {
        $('span2').innerHTML = $('dy').innerHTML
    } else {
        $('span2').innerHTML = $('qx').innerHTML
    }
    $('phone2').value = phone;
    $('status2').setAttribute("value", status);
    $('dy-tanchu2').style.display = "";
    $('phone2').focus();
}

// 隐藏div:dy-tanchu2清除数据
function csubScription2() {
    $('phone2').value = "";
    $('yzm2').value = "";
    $('dy-tanchu2').style.display = "none";
}

// 订阅
// 输入手机号码，发送请求
function send() {
    var phone = $('phone1').value;
    var status = $('status1').value;
    var captcha = $('captcha').value;

    if(phone =="") {
        alert("请输入手机号码");
        return false;
    }

    // 手机号码验证
    if (phone.length != 11) {
        alert("请输入正确的手机号码");
        return false;
    }

    new Ajax.Request('/tuangou_notices/get_yzm?phone='+phone+'&status='+status+"&captcha="+captcha,{
        method:'get',
        asynchronous:false ,
        onSuccess: function(transport){
            var response = transport.responseText;
            $('user_search').innerHTML=response;
        }
    });
    var flag = document.getElementById("user_search").innerHTML.split(".");
    if(flag[0] != 4) {
        if(flag[0] == 8) {
            alert(flag[1]);
            return false;
        }
        alert(flag[1]);
        csubScription1();
        return false;
    }
    alert(flag[1]);
    subScription2(phone,status);
    csubScription1();
    return false;
}

// 输入验证码，再次发送。
function resend() {
    var phone = $('phone2').value;
    var status = $('status2').value;
    var yzm = $('yzm2').value;
    new Ajax.Request('/tuangou_notices/confirm?phone='+phone+"&status="+status+"&yzm="+yzm,{
        method:'get',
        asynchronous:false,
        onSuccess: function(transport){
            var response = transport.responseText;
            $('user_search').innerHTML=response;
        }
    });
    var flag = $('user_search').innerHTML.split(".");
    alert(flag[1]);
    csubScription2();
    return false;
}

function doClose(self) {
    var divId = self.parentNode.parentNode.parentNode.getAttribute("id");
    switch(divId)
    {
        case "dy-tanchu1":
            csubScription1();
            break
        case "dy-tanchu2":
            csubScription2();
            break
        case "qx-tanchu1" :
            cunSubScription1();
            break
        case "qx-tanchu2":
            cunSubScription2();
            break
        default:
    }
    return false
}

function doClose2(id)
{
	$(id).style.display="none";
}

function doClick(){
    var email = document.getElementById("dy-input").value;
    //var regEmail = /^([a-z0-9]*[-_]?[a-z0-9]+)*@([a-z0-9]*[-_]?[a-z0-9]+)+[\.][a-z]{2,3}([\.][a-z]{2})?$/i;
    var regEmail = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
    if (!regEmail.test(email.trim())) {
        alert("email格式不正确");
        return false;
    }
    return true;
}
