const requireRole = (...allowedRoles) => {
  return (req, res, next) => {
    
    if (!req.user || !req.user.role) {
      return res.status(403).json({
        success: false,
        message: 'Forbidden. No role information found on the token.',
      });
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: `Forbidden. This action requires one of the following roles: [${allowedRoles.join(', ')}]. Your role: '${req.user.role}'.`,
      });
    }

    next();
  };
};

module.exports = { requireRole };
