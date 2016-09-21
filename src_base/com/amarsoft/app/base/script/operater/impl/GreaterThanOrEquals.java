package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.operater.CompareOperator;
import com.amarsoft.are.util.DataConvert;

/**
 * >= 大于等于 判断
 * @author xjzhao@amarsoft.com
 */
public class GreaterThanOrEquals extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		Equals eq = new Equals();
		boolean flag = eq.compare(a, b, extendedPropoty);
		if(flag) return flag;
		if(a == null) return false;
		
		if(a instanceof String && b instanceof String)
		{
			return ((String)a).compareTo((String)b) >= 0;
		}
		else if(a instanceof Number && b instanceof Number)
		{
			return ((Number)a).doubleValue() >= ((Double)b).doubleValue();
		}
		else if(a instanceof Number && b instanceof String)
		{
			return ((Number)a).doubleValue() >= DataConvert.toDouble((String)b);
		}
		else if(a instanceof String && b instanceof Number)
		{
			return  DataConvert.toDouble((String)a) >= ((Double)b).doubleValue();
		}
		else
			throw new ALSException("ED1026",a.toString());
	}
}
