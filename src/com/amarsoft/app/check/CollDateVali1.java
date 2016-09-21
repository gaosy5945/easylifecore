package com.amarsoft.app.check;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.dw.ui.validator.CustomValidator;


/**
 * @author t-zhangq2
 * 日期不早于今天
 */
public class CollDateVali1 extends CustomValidator{
	public String valid(String date) throws Exception{
		String d = DateHelper.getBusinessDate();
		int result = DateHelper.getDays(d, date);
		if(result>0) return "";
		else  return "false";
	}
}
