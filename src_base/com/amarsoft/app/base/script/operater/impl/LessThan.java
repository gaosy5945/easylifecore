package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.operater.CompareOperator;
import com.amarsoft.are.util.DataConvert;

/**
 * < Ð¡ÓÚ ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class LessThan extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		if(a == null) return false;
		
		if(a instanceof String && b instanceof String)
		{
			return ((String)a).compareTo((String)b) < 0;
		}
		else if(a instanceof Number && b instanceof Number)
		{
			return ((Number)a).doubleValue() < ((Number)b).doubleValue();
		}
		else if(a instanceof Number && b instanceof String)
		{
			return ((Number)a).doubleValue() < DataConvert.toDouble((String)b);
		}
		else if(a instanceof String && b instanceof Number)
		{
			return DataConvert.toDouble((String)a) < ((Double)b).doubleValue();
		}
		else
			throw new ALSException("ED1026",a.toString());
	}
}
