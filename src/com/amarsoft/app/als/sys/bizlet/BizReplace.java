package com.amarsoft.app.als.sys.bizlet;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BizReplace extends Bizlet{

	@Override
	public Object run(Transaction arg0) throws Exception {
		String str=(String)this.getAttribute("str");
		if(str==null) return "";
		str=StringFunction.replace(str, ",","','");
	 
		return str;
	}
 

}
