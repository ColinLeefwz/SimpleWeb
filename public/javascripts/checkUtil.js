function onlyInNum(evt) {
    if (window.event) {
        var charCode = evt.code
    } else if (evt.which) {
        var charCode = evt.which
    }
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}   

function onlyInFloat(evt) {
    if (window.event) {
        var charCode = evt.code
    } else if (evt.which) {
        var charCode = evt.which
    }
    if (((charCode > 31 && charCode < 46) || charCode > 46) && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function returnChar(evt) {
    if (window.event) {
        var charCode = evt.code
    } else if (evt.which) {
        var charCode = evt.which
    }
    return charCode;
}

function pay_submit() {
    if (phone_validate('phone') && phone_validate('phone_con')) {
        document.getElementById('payform').submit();
    }
}

function phone_change() {
    if (document.getElementById('phoneOpt').value == 1) {
        document.getElementById('phone').value = '<%= request[:phone] -%> '
    } else {
        document.getElementById('phone').value = '';
    }
}

function phone_validate(p_id) {
    var p = document.getElementById(p_id).value;
    var patrn = /^0?1((3)|(5)|(8))\d{9}$/;
    if(!patrn.exec(p)) {
        document.getElementById(p_id + "_err").innerHTML = '<label>' + '请输入正确的手机号码， 如：13012345678' + '</label>';
        document.getElementById(p_id + "_err").style.display = '';
        return false;
    } else {
        document.getElementById(p_id + "_err").style.display = 'none';
        if (p_id == 'phone_con') {
            return phone_confirmation();
        }
        return true;
    }
}

function phone_confirmation() {
    if (document.getElementById('phone_con').value == '' || document.getElementById('phone').value != document.getElementById('phone_con').value) {
        document.getElementById('phone_con_err').innerHTML = '<label>' + '手机号码不相匹配' + '</label>';
        document.getElementById('phone_con_err').style.display = '';
        return false;
    } else {
        document.getElementById('phone_con_err').style.display = 'none';
        return true;
    }
}
