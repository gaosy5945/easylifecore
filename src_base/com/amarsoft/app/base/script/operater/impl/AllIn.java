package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.operater.CompareOperator;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.lang.StringX;

/**
 * Contain °üº¬  ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class AllIn extends CompareOperator {
	public static String split = ",";
	
	public boolean compare(Object b, Object a,Object... extendedPropoty) throws Exception {
		if(a==null||a.equals("")) return true;
		if(b==null) b="";
		if(a instanceof String && b instanceof String){
			if(StringX.isEmpty((String)b)) return true;
			String s[]=((String)b).split(",");
			boolean result=true;
			for(String s1:s){
				if(!StringHelper.contains((String)a,s1, ",")){
					result=false;
					break;
				}
			}
			return result;
		}
		else
			throw new ALSException("ED1026",a.toString());
	}
}
