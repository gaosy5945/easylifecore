package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ������������ɾ������ʵ���ӿ�
 * @author ������
 */
public class DelPcsInstnc extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//���̱�š��û����
		String taskSerialNo = (String)this.getAttribute("TaskSerialNo");
		String pcsInstncId = (String)this.getAttribute("PcsInstncId");
		
		//������������ɾ������ʵ���ӿ�
		try{
			//BPMPInstance.DelPcsInstnc(pcsInstncId, Sqlca.getConnection());
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
		return "true@��ȡ�ɹ�";
		
	}
	
}
