package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.operater.CompareOperator;
import com.amarsoft.are.lang.StringX;

/**
 * in °üº¬  ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class Like extends CompareOperator {
	
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		if(a==null||a.equals("")) return true;
		if(b==null) b="";
		if(a instanceof String && b instanceof String){
			if(StringX.isEmpty((String)b)) return true;
			return (((String)a).indexOf((String)b)) >= 0;
		}
		else
			throw new ALSException("ED1026",a.toString());
	}
}
