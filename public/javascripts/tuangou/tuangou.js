function checkSize(obj_file){
    var size=0;
    if(navigator.userAgent.indexOf("MSIE")>-1){
      var obj = new ActiveXObject("Scripting.FileSystemObject");
      size = obj.getFile(obj_file.value).size;
    }else if(navigator.userAgent.indexOf("Firefox")>-1 
    || navigator.userAgent.indexOf("Chrome")>-1){
      size=obj_file.files.item(0).size;           
      }else{
      return false;
    }
    if(size>150000){
      document.getElementById("errDiv").innerHTML="上傳檔案不得超過 150K ";
      return false;
    }
    return true;
  }
  function getFullPath(obj) { 
    if(obj) { //ie 
      if (window.navigator.userAgent.indexOf("MSIE") > -1) { 
        obj.select(); 
        return document.selection.createRange().text; 
        } else if(window.navigator.userAgent.indexOf("Firefox") > -1) { //firefox  
        if(obj.files) { 
          return obj.files.item(0).getAsDataURL(); 
          } else {
          return obj.value; 
        }
        } else if(window.navigator.userAgent.indexOf("Chrome") > -1) {
        if(obj.files) { 
          return obj.files.item(0).getAsDataURL(); 
          } else {
          return obj.value; 
        }
        } else {
        return obj.value; 
      }
    }
  } 
  function showUploadFile(obj) {
    if (checkSize(obj)) {
      document.getElementById('file_show').src=getFullPath(obj);
    }
  }
  function compareMoney(ele) {
    var base_price =  document.getElementById('discount_base_price').value;
    var money =  document.getElementById('discount_money').value;
    if (base_price != '' && money != '') {
      if (parseInt(base_price, 10) < parseInt(money, 10)) {
        if (ele == 'base_price') {
      document.getElementById("errDiv").innerHTML="商品原价不能低于团购价!";
          document.getElementById('discount_base_price').focus();
          } else if (ele == 'money') {
      document.getElementById("errDiv").innerHTML="商品团购价不能高于原价!";
          document.getElementById('discount_money').focus();
        }
      }
    }
  }
  function compareNumber(ele) {
    var low =  document.getElementById('shop_tuangou_low').value;
    var high =  document.getElementById('shop_tuangou_high').value;
    if (low != '' && high != '') {
      if (parseInt(high, 10) < parseInt(low, 10)) {
        if (ele == 'low') {
      document.getElementById("errDiv").innerHTML="商品最低团购数量不能高于最高团购数量!"
          document.getElementById('shop_tuangou_low').focus();
          } else if (ele == 'high') {
      document.getElementById("errDiv").innerHTML="商品最高团购数量不能低于最低团购数量!"
          document.getElementById('shop_tuangou_high').focus();
        }
      }
    }
  }
  function compareDate(ele) {
    var beginday =  document.getElementById('discount_beginday').value;
    var endday =  document.getElementById('discount_endday').value;
    var start_time =  document.getElementById('shop_tuangou_start_time').value;
    var end_time =  document.getElementById('shop_tuangou_end_time').value;
    if (beginday != '' && endday != '') {
      if (beginday > endday) {
        if (ele == 'beginday') {
      document.getElementById("errDiv").innerHTML="团购券消费开始时间不能晚于团购券消费结束时间!"
          document.getElementById('discount_beginday').focus();
          } else if (ele == 'endday') {
      document.getElementById("errDiv").innerHTML="团购券消费结束时间不能早于团购券消费开始时间!"
          document.getElementById('discount_endday').focus();
        }
      }
    }
    if (start_time != '' && end_time != '') {
      if (start_time > end_time) {
        if (ele == 'start_time') {
      document.getElementById("errDiv").innerHTML="团购发布开始时间不能晚于团购发布结束时间!";
          document.getElementById('shop_tuangou_start_time').focus();
          } else if (ele == 'end_time') {
      document.getElementById("errDiv").innerHTML="团购发布结束时间不能早于团购发布开始时间!";
          document.getElementById('shop_tuangou_end_time').focus();
        }
      }
    }
/**
    if (beginday != '' && start_time != '') {
      if (beginday < start_time) {
        if (ele == 'start_time') {
      document.getElementById("errDiv").innerHTML="团购发布开始时间不能晚于团购券消费开始时间!";
          document.getElementById('shop_tuangou_start_time').focus();
          } else if (ele == 'beginday') {
      document.getElementById("errDiv").innerHTML="团购券消费开始时间不能早于团购发布开始时间!";
          document.getElementById('discount_beginday').focus();
        }
      }
    }
*/
  }
