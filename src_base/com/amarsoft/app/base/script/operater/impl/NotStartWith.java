package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.script.operater.CompareOperator;

/**
 * NoStart 开头不是  判断
 * @author xjzhao@amarsoft.com
 */
public class NotStartWith extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		Contains operator = new Contains();
		return !operator.compare(a, b);
	}
}
