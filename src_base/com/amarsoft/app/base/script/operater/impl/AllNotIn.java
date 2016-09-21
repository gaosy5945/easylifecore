package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.script.operater.CompareOperator;

/**
 * not in ²»·´°üº¬  ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class AllNotIn extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		AnyIn in = new AnyIn();
		return !in.compare(a, b);
	}
}
