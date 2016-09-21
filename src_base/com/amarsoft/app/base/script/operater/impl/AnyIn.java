package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.operater.CompareOperator;

/**
 * Contain °üº¬  ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class AnyIn extends CompareOperator {
	public static String split = ",";
	
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		if(a==null) a="";
		if(b==null) b="";
		if(a instanceof String && b instanceof String){
			String a1 = (String)a;
			String b1 = (String)b;
			if(a1.indexOf(split+b1+split)>=0) return true;
			else if(a1.startsWith(b1+split)) return true;
			else if(a1.endsWith(split+b1)) return true;
			else if(a1.equals(b1)) return true;
			else return false;
		}
		else
			throw new ALSException("ED1026",a.toString());
	}
}
