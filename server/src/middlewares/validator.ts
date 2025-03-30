import { body } from "express-validator";

export const registerValidator = [
    body('email').isEmail().withMessage("Please enter a valid email").normalizeEmail(),
    body('name').isString().withMessage("Name must be a String").escape(),
    body('password').isLength({min:6}).withMessage("Password must be at least 6 characters").matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/).withMessage("Password must be at least 8 characters long and include at least one lowercase letter, one uppercase letter, one number, and one special character.").escape()
]

