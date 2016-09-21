package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.script.operater.CompareOperator;

/**
 * != ²»µÈÓÚ ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class NotEquals extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		Equals operator = new Equals();
		return !operator.compare(a, b);
	}
}
