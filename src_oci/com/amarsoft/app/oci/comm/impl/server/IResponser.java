package com.amarsoft.app.oci.comm.impl.server;

import java.util.Map;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;

/**
 * <p>ҵ������ӿ�<br>
 * ��Ϊ�����ʱ���ã����������ӦMessage</p>
 * @author xjzhao
 *
 */
public interface IResponser {
	/**
	 * ͨ������Message��Ϣִ�и÷����������ӦMessage��ֵ
	 * @param trans
	 * @throws Exception
	 */
	public void dispose(OCITransaction trans) throws Exception;
	
	/**
	 * ����ϵͳ������Ϣ�����ز�ͬϵͳҪ��Ĵ�����ϢMap��ƴװ��ͬ�Ĵ�����
	 * @param e 
	 * @param trans
	 * @return	Map ������ϢMap
	 */
	public Map<String, String> getErrorMap(OCIException e, OCITransaction trans);
}
