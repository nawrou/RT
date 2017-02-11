/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cl_test_krl.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: qle-guen <qle-guen@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/10 11:00:05 by qle-guen          #+#    #+#             */
/*   Updated: 2017/02/11 15:40:35 by qle-guen         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "cl.h"
#include "cl_interface.h"
#include "libvect.h"
#include "libfmt.h"
#include "parameters.h"

#define FILENAME	"sources/cl/test.cl"
#define KRLNAME		"test"

static bool
	test_krl_init
	(t_cl_info *info
	, t_cl_krl *test_krl)
{
	int			fd;
	int			ret;
	t_vect		build_line;

	vect_init(&build_line);
	if ((fd = open(FILENAME, O_RDONLY)) < 0)
		return (ERR("cannot open file " FILENAME, false, 0));
	cl_krl_init(test_krl, 1);
	test_krl->sizes[0] = 1;
	VECT_STRADD(&build_line, KRLNAME ":");
	VECT_STRADD(&build_line, "-I sources/cl ");
	FMT_VECT(&build_line, "-D WIDTH=%a ", WIN_W);
	FMT_VECT(&build_line, "-D HEIGHT=%a ", WIN_H);
	FMT_VECT(&build_line, "-D AREA=%a ", WIN_W * WIN_H);
	FMT_VECT(&build_line, "-D XCENTER=%a ", WIN_W / 2);
	FMT_VECT(&build_line, "-D YCENTER=%a ", WIN_H / 2);
	VECHO(&build_line);
	if ((ret = cl_krl_build(info
		, test_krl
		, fd
		, &build_line)) != CL_SUCCESS)
		return (ERR("cannot build kernel, opencl error %a", false, ret));
	close(fd);
	free(build_line.data);
	return (true);
}

bool
	cl_test_krl
	(t_rt *rt)
{
	int			ret;
	size_t		work_size;
	t_cl		cl;

	cl_init(&cl.info);
	if (!test_krl_init(&cl.info, &cl.main_krl))
		return (ERR("failed to init kernel", false, 0));
	free(cl.main_krl.args);
	free(cl.main_krl.sizes);
	if (!cl_main_krl_update_camera(&cl, rt->scn->c_cam))
		return (ERR("cannot set camera arg in kernel", false, 0));
	if (!cl_main_krl_update_buffers(&cl, rt->scn))
		return (ERR("cannot update buffers", false, 0));
	work_size = 1;
	if ((ret = cl_krl_exec(&cl.info, cl.main_krl.krl, 1, &work_size))
		!= CL_SUCCESS)
		return (ERR("cannot execute kernel, opencl error %a", false, ret));
	return (true);
}
