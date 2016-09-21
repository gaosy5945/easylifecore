package com.amarsoft.app.base.script.operater.impl;

import com.amarsoft.app.base.script.operater.CompareOperator;
import com.amarsoft.are.util.DataConvert;

/**
 * = µÈÓÚ ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class Equals extends CompareOperator {
	public boolean compare(Object a, Object b,Object... extendedPropoty) throws Exception {
		if(a==null&&b!=null){
			return false;
		}
		else if(a!=null&&b==null){
			return false;
		}
		else if(a==null&&b==null){
			return true;
		}
		else if(a instanceof String && b instanceof String){
			return ((String)a).equals((String)b);
		}
		else if(a instanceof Number && b instanceof Number){
			return Math.abs(((Number)a).doubleValue() - ((Number)b).doubleValue())< 0.0000000001;
		}
		else if(a instanceof Number && b instanceof String){
			return Math.abs(((Number)a).doubleValue() - DataConvert.toDouble((String)b))< 0.0000000001;
		}
		else if(a instanceof String && b instanceof Number){
			return Math.abs(DataConvert.toDouble((String)a) - ((Number)b).doubleValue())< 0.0000000001;
		}
		return a.equals(b);
	}
}
