package com.amarsoft.app.oci.comm.impl.client;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;

/**
 * <p>�˽ӿڶ�����ͨѶ�еĻ����ķ��ͱ��ĵĹ���<br>
 *    �����˲�ͬͨѶ��ʽ</p>
 * @author xjzhao
 *
 */
public interface IRequester {
	/**
	 * <p>���ͱ��Ĳ����ܷ��ر���</p>
	 * @param requestedStr δת��Ĵ����ͱ���
	 * @return
	 * @throws Exception
	 */
	public Object execute(OCITransaction transaction) throws OCIException;
}
