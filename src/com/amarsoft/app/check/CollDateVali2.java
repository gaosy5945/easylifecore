package com.amarsoft.app.check;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.dw.ui.validator.CustomValidator;


/**
 * @author t-zhangq2
 * ���ڲ����ڽ���
 */
public class CollDateVali2 extends CustomValidator{
	public String valid(String date) throws Exception{
		String d = DateHelper.getBusinessDate();
		int result = DateHelper.getDays(d, date);
		if(result<0) return "false";
		else  return "";
	}
}
