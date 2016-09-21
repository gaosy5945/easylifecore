package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.script.operater.CompareOperator;

/**
 * NoEnd Ω·Œ≤≤ª «  ≈–∂œ
 * @author xjzhao@amarsoft.com
 */
public class NotEndsWith extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		EndsWith operator = new EndsWith();
		return !operator.compare(a, b);
	}
}
