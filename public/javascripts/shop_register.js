function $(id)
{
	return document.getElementById(id);
}
//验证参数数组格式[action,id,errorId,isNull,alertStyle,successStyle,failStyle,minLength,maxLength,name,type]
//参数说明：动作类型，控件id，错误显示id，是否可以为空，提示样式，验证成功样式，验证失败样式，最小长度，最大长度，验证文字名称
var validate={};
validate.validate=function(arr)
{
	var val=$(arr[1]).value;
	if(arr[3]==true&&val=='')
		return;
	var failMes="";
	var alertMes="";
	if(arr[10]=='str')
		alertMes=failMes="*"+arr[9]+"的长度在"+arr[7]+"到"+arr[8]+"个字符！";
	else if(arr[10]=='email')
	{
		failMes="*email格式不正确！";
		alertMes="";
	}else if(arr[10]=='mobile')
	{
		failMes="*手机号码无效！";
		alertMes="";
	}else if(arr[10]=='password')
	{
		failMes="*两次输入的密码不一致！";
		alertMes="";
	}else if(arr[10]=='url')
	{
		failMes="*网址格式不正确！";
		alertMes="";
	}

	if(arr[0]=='focus')
	{
		$(arr[2]).innerHTML=alertMes;
		$(arr[2]).className=arr[4];
	}else if(arr[0]=='blur')
	{
		var valida=true;
		if(arr[10]=='email')
		{
			if(validate.isEmail(val)==true)
				valida=true;
			else
				valida=false;
		}else if(arr[10]=='mobile')
		{
			if(validate.isMobile(val)==true)
				valida=true;
			else
				valida=false;
		}else if(arr[10]=='str')
		{
			if(val.length<arr[7]||val.length>arr[8])
				valida=false;
			else 
				valida=true;
		}else if(arr[10]=='password')
		{
			var confPassword=$(arr[1]+"_confirmation").value;
			if(val==confPassword)
				valida=true;
			else 
				valida=false;
		}else if(arr[10]=='url')
		{
			if(validate.isURL(val)==true)
				valida=true;
			else
				valida=false;
		}
		if(valida==true)
		{
			$(arr[2]).innerHTML="";
			$(arr[2]).className=arr[5];
		}else
		{
			$(arr[2]).innerHTML=failMes;
			$(arr[2]).className=arr[6];
		}
	}
};

validate.isMobile=function(value)    
{     
	 if(/^13\d{9}$/g.test(value)||(/^15[0-35-9]\d{8}$/g.test(value)) || (/^18[05-9]\d{8}$/g.test(value)))
	{       
        return true;     
    }else
	{     
        return false;     
    }     
  
}; 

validate.isEmail=function(value)
{
	var myreg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
    if(!myreg.test(value))
		return false;
	else 
		return true;
};

validate.isURL=function(url)
{
    var regExp = /(http[s]?|ftp):\/\/[^\/\.]+?\..+\w$/i;
    if(url.match(regExp))
		return true;
    else 
		return false;        
};