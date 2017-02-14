/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   obj_def.h                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: qle-guen <qle-guen@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/10 10:34:17 by qle-guen          #+#    #+#             */
/*   Updated: 2017/02/14 17:31:29 by lgatibel         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef OBJ_DEF_H
# define OBJ_DEF_H

# include "../../include/obj_types.h"

typedef struct		s_obj
{
	short			type;
	float3			pos;
	float3			rot;
	float3			clr;
	float			opacity;
	float			width;
	float			height;
	float			radius;
	float			specolor;
	float			reflex;
	float			refract;
}					t_obj;

typedef struct		s_lgt
{
	float3			pos;
	float3			rot;
	float			intensity;
	float			shiness;
	float			mshiness;
}					t_lgt;

typedef struct		s_cam
{
	float3			pos;
	float3			rot;
	short			focal;
}					t_cam;

#endif
