package com.amarsoft.app.base.util;


import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;

public class AmarScriptHelper {
	public static String SCRIPT_PARAMETER_STRING_START = "{#";
	public static String SCRIPT_PARAMETER_STRING_END = "}";


	public static Any getScriptValue(String script, BusinessObjectManager bomanager) throws Exception {

		if (script.indexOf(AmarScriptHelper.SCRIPT_PARAMETER_STRING_START) >= 0) {
			throw new Exception("脚本-" + script + "参数未替换完整，请确认所需参数是否都已加载到对应对象");
		}
		try {
			Transaction sqlca = null;
			if(bomanager.getTx()!=null){
				sqlca = Transaction.createTransaction(bomanager.getTx());
			}
			else{
				BizObjectManager manager = JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
				sqlca =new Transaction(manager.getDatabase());
			}
			Any a= Expression.getExpressionValue(script, sqlca);
			if(sqlca!=null) sqlca.disConnect();
			return a;
		} catch (Exception e) {
			throw new Exception("脚本错误:" + script);
		}
	}
}
