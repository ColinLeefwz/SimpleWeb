
function exec(context)
	builder = luajava.newInstance("android.app.AlertDialog$Builder", context)
	builder:setMessage(luajava.newInstance("java.lang.String", "发现新版本"))
	builder:setTitle(luajava.newInstance("java.lang.String", "更新提示"))
	button_ok = {}
	button_no = {}
	function button_ok.onClick(dialog, which)
		dialog:dismiss();
		local updateClazz = luajava.bindClass("cn.dface.utils.update.UpdateManager")
		local mUpdateManager = updateClazz:getInstance(context);
		mUpdateManager:showDownloadDialog();
	end
	function button_no.onClick(dialog, which)
		dialog:dismiss();
	end
	buttonProxyOk = luajava.createProxy("android.content.DialogInterface$OnClickListener",  button_ok)
	buttonProxyNo = luajava.createProxy("android.content.DialogInterface$OnClickListener",  button_no)	
	builder:setPositiveButton(luajava.newInstance("java.lang.String", "确认"), buttonProxyOk)
	builder:setNegativeButton(luajava.newInstance("java.lang.String", "取消"), buttonProxyNo)
	builder:create()
	builder:show()
	return "return form lua"
end


