package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.script.operater.CompareOperator;

/**
 * NoContain ²»°üº¬ ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class NotContains extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		Contains operator = new Contains();
		return !operator.compare(a, b);
	}
}
