/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cl.h                                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: qle-guen <qle-guen@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/09 15:06:29 by qle-guen          #+#    #+#             */
/*   Updated: 2017/02/10 10:17:07 by qle-guen         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef CL_H
# define CL_H

# include "libcl.h"

typedef struct	s_cl
{
	t_cl_info	info;
	t_cl_krl	ray_send_krl;
	cl_mem		objs;
	cl_mem		lgts;
	short		n_objs;
	short		n_lgts;
}				t_cl;

bool			cl_main_krl_init(t_cl *cl);
bool			cl_main_krl_exec(t_cl *cl, t_scene *scene);

#endif
