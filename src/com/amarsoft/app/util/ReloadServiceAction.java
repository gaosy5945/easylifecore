package com.amarsoft.app.util;

import com.amarsoft.are.ARE;
import com.amarsoft.are.AREException;
import com.amarsoft.are.AREServiceStub;

/**
 * ����װ��ARE��Javaҵ�����������
 * @author xhgao
 * 
 */
public class ReloadServiceAction {
	
	private String serviceId = "JBO"; //ARE ������

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String reloadService() throws Exception{
		//�������
		String s=reloadSingleService(serviceId);
		if(s.equals("SUCCESS")) reloadSingleService("OW");
		return s;
	}
	
	public String reloadSingleService(String serviceId) throws Exception{
		//�������
		String sReturn = "SUCCESS";
		AREServiceStub s = ARE.getServiceStub(serviceId);
		ARE.getLog().trace("[������]"+serviceId+" ,[stub]��"+s);
		if(s!=null) {
			try {
				s.loadService();
				s.initService();
				ARE.getLog().trace("���ط���["+serviceId+"]�ɹ���");
			} catch (AREException ex) {
				ARE.getLog().debug("���ط���["+serviceId+"]ʧ�ܣ�"+ex);
				sReturn = "FAILED";
			}
		}
		return sReturn;
	}
}
