package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.operater.CompareOperator;

/**
 * Start ¿ªÍ·ÊÇ  ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class StartsWith extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		if(a==null) a="";
		if(b==null) b="";
		if(a instanceof String && b instanceof String){
			return ((String)a).startsWith((String)b);
		}
		else
			throw new ALSException("ED1026",a.toString());
	}
}
